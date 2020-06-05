#!/usr/bin/env python3
#
# File:
#   homepagemk.py
#
# Usage:
#   homepagemk.py [OPTIONS] [VAR=VAL [VAR=VAL...]] TEMPLATE DOC_ROOT
#   homepagemk.py --help
#
# Description:
#   Make documentation home page index.html.
#
# /*! \file */
# /*! \cond RNMAKE_DOXY*/

import sys
import os
import time
import shutil
import re
import getopt

from pprint import pprint

# fix up python path
sys.path.insert(0, os.path.realpath(os.path.dirname(__file__)))

try:
  from rnmake.color import ColorfulOutput
  from rnmake.atat import AtAt, AtAtError
except ImportError as e:
  print(f"{e}: Expeceted to be found in 'PREFIX/rnmake/utils/rnmake'")
  sys.exit(8)
except AttributeError as e:
  print(f"{e}")
  sys.exit(8)

# template @variable@ substitution names to values basic set
AtAtBasicSet = {
  'author':         None,
  'doxy_href':      None,
  'favicon':        None,
  'license':        None,
  'license_file':   None,
  'org':            None,
  'org_abbrev':     None,
  'org_fq':         None,
  'org_logo':       None,
  'org_url':        None,
  'pkg_name':       None,
  'pkg_ver':        None,
  'pub_href':       None,
  'pydoc_href':     None,
  'rel_href_iter':  None,
  'rel_ul_iter':    None,
}

# -----------------------------------------------------------------------------
class UsageError(Exception):
  """ Command-Line Options UsageError Exception Class. """
  def __init__(self, msg):
    self.msg = msg

# -----------------------------------------------------------------------------
class HomeMaker:
  """ Documentation home page index.html 'stay-at-home' maker class). """

  def __init__(self):
    self.out        = ColorfulOutput()
    self.atat       = AtAt(out=self.out)
    self.paths      = {}
    self.html_vars  = {}

  def make_vars(self):
    self.verbose(f"Making documentation variables.")

    self.paths['template']    = self.kwargs['template']
    self.paths['doc_root']    = self.kwargs['doc_root']

    # required
    if not os.path.isfile(self.paths['template']):
      self.fatal(4, f"{self.paths['template']}: Template does not exist")
    if not os.path.isdir(self.paths['doc_root']):
      self.fatal(4, f"{self.paths['doc_root']}: Document root does not exist")

    self.paths['index_html']  = os.path.join(self.paths['doc_root'],
                                             'index.html')
    self.paths['images_path'] = self.kwargs['images_path']
    self.paths['pub_dir']     = self.kwargs['pub_dir']
    self.paths['doxy_index']  = self.kwargs['doxy_index']
    self.paths['pydoc_index'] = self.kwargs['pydoc_index']
    self.paths['rel_files']   = self.kwargs['rel_files']

    # check index files
    for k in ['doxy_index', 'pydoc_index']:
      if self.paths[k] is not None:
        fname = os.path.join(self.paths['doc_root'], self.paths[k])
        if not os.path.isfile(fname):
          self.paths[k] = None

    # check release files
    rel = []
    for rfile in self.paths['rel_files']:
      if rfile:
        fname = os.path.join(self.paths['doc_root'], rfile)
        if os.path.isfile(fname):
          rel += [rfile]
          if rfile in ['LICENSE', 'EULA.md']:
            self.paths['license_file'] = rfile
    self.paths['rel_files'] = rel

    # check published directory
    if self.paths['pub_dir']:
      dname = os.path.join(self.paths['doc_root'], self.paths['pub_dir'])
      fname = os.path.join(dname, 'index.html')
      if os.path.isfile(fname):
        self.paths['pub_index'] = os.path.join(self.paths['pub_dir'], fname);
      elif os.path.isdir(dname):
        self.paths['pub_index'] = self.paths['pub_dir'];
      else:
          self.paths['pub_index'] = None
    else:
      self.paths['pub_index'] = None

    self.debug('paths =', self.paths)

    self.make_atat_vars()

    self.verbose('')

  def make_atat_vars(self):
    """ Make and set all working atat varibles for template processing. """
    # atat variable dictionary 
    atatvar = AtAtBasicSet.copy()

    # command-line overrides
    atatvar.update(self.kwargs['atat'])

    # check image files
    for k in ['favicon', 'org_logo']:
      atatvar[k] = self.search_for_file(atatvar.get(k),
                                        self.paths['images_path'],
                                        self.paths['doc_root'])

    # callable variables
    atatvar['rel_href_iter'] = self.atat_rel_href_iter
    atatvar['rel_ul_iter']   = self.atat_rel_ul_iter
    atatvar['doxy_href']     = self.atat_doxy_href
    atatvar['pydoc_href']    = self.atat_pydoc_href
    atatvar['pub_href']      = self.atat_pub_href

    # upper case names and remove undef'd
    for k,v in atatvar.items():
      if v is not None:
        self.html_vars[k.upper()] = v

    self.atat.merge_vars(self.html_vars)

    self.debug('html_vars =', self.html_vars)

  def search_for_file(self, filename, path_list, root=''):
    """ Search for file in distribution. """
    if not filename:
      return None
    filename = os.path.basename(filename)
    for dname in path_list:
      fname = os.path.join(root, dname, filename)
      if os.path.isfile(fname):
        return fname
    return None

  def atat_rel_href_iter(self, fp, var, fmt):
    if len(self.paths['rel_files']) == 0:
      print("<p>no files</p>", file=fp)
    else:
      for fname in self.paths['rel_files']:
        print(f"{fmt}".format(fname, fname), file=fp)

  def atat_rel_ul_iter(self, fp, var, fmt):
    for fname in self.paths['rel_files']:
      print(f"{fmt}".format(fname), file=fp)

  def atat_doxy_href(self, fp, var, fmt):
    href = self.paths['doxy_index']
    if href:
      print(f"{fmt}".format(href, 'source documentation'), file=fp)
    else:
      print("<p>no documentation</p>", file=fp)

  def atat_pydoc_href(self, fp, var, fmt):
    href = self.paths['pydoc_index']
    if href:
      print(f"{fmt}".format(href, 'python documentation'), file=fp)
    else:
      print("<p>no documentation</p>", file=fp)

  def atat_pub_href(self, fp, var, fmt):
    href = self.paths['pub_index']
    if href:
      print(f"{fmt}".format(href, 'papers'), file=fp)
    else:
      print("<p>no documentation</p>", file=fp)

  def make_html_index(self):
    self.verbose(f"Making {self.paths['index_html']}")
    if not self.paths['template']:
      self.out.iowarning("No template file - skipping",
                         filename=self.paths['template'])
      return
    self.verbose(f"Parsing template {self.paths['template']}")
    postfile = self.atat.replace_in_file(self.paths['template'], False)
    self.verbose("Moving to index.html")
    shutil.move(postfile, self.paths['index_html'])
    self.verbose('')

  def show(self):
    """ Show what and such. """
    from rnmake.atat import AtAtPrettyPrint
    pretty = AtAtPrettyPrint(self.atat)

    # pass 1: template not required
    pass2 = []
    for what in self.kwargs['show']:
      if what == 'def':
        pretty.show_defined()
        print()
      else:
        pass2.append(what)

    if not self.paths['template']:
      self.out.error("No template")
      return

    if len(pass2) > 0 and not self.atat.is_template_loaded():
      try:
        self.atat.load_template(self.kwargs['template'])
      except AtAtError as e:
        self.out.ioerror(e.msg, filename=e.filename)
        return

    # pass 2: need (parsed) template
    for what in pass2:
      if what == 'ref':
        pretty.show_referenced()
      elif what == 'pre':
        pretty.show_preparsed()
      elif what == 'post':
        pretty.show_postparsed()
      print()
 
  def verbose(self, msg):
    if self.kwargs['verbose']:
      self.out.cprint('normal', msg)

  def debug(self, what, *objs):
    if self.kwargs['debug']:
      self.out.debug(what, *objs)

  def fatal(self, ec, *emsgs, filename=None, line_num=0):
    """
    Show fatal message and exit.

    Parameters:
      ec        Exit code.
      emsgs     Arguments to the message.
      filename  Optional filename associated with I/O.
      line_num  Option line number of filename.
    """
    self.out.iofatal(*emsgs, filename=filename, line_num=line_num)
    sys.exit(ec)

  def turn_off_color(self):
    """ Disable color output. """
    self.out.disable_color()

  def print_usage_error(self, *args):
    """ Print error usage message. """
    emsg = ': '.join([f"{a}" for a in args])
    if emsg:
      print(f"{self.argv0}: error: {emsg}")
    else:
      print(f"{self.argv0}: error")
    print(f"Try '{self.argv0} --help' for more information.")
  
  def print_help(self):
    """ Print command-line help. """
    print(f"""\
Usage: {self.argv0} [OPTIONS] [VAR=VAL [VAR=VAL...]] TEMPLATE DOC_ROOT
       {self.argv0} --help

Generate top-level home index.html page for documetation distribution.
The index.html page will be created under the DOC_ROOT path directory.

Options:
      --debug               Enable debugging.

      --doxy-index=INDEX    Doxygen generated index.html page.
                            Relative path to DOC_ROOT.

      --images-path=PATH    Colon separated images search path.
                            Relative path to DOC_ROOT.

      --no-color            Disable color output.

      --pub-dir=DIR         Published papaers directory.
                            Relative path to DOC_ROOT.

      --pydoc-index=INDEX   Pydoc generated index.html page.
                            Relative path to DOC_ROOT.

      --rel-files=FILES     Semi-colon separated release file basenames.

      --show=WHAT           Show WHAT to stdout. The show option disables any
                            file updates. May be iterated. WHAT is one of:
                              all   Show all WHATs.
                              def   Show defined atat variables.
                              ref   Show atat variables referenced in template.
                              pre   Show pre-parsed template contents.
                              post  Show post-parsed template contents.
 
      --verbose             Print verbose status messages.
                            Default: False
  
  -h, --help                Display this help and exit.

Description:
TEMPLATE
Home page index.html template file. File contains atat variables and formats.
From the template, an index.html file is created.

DOC_ROOT
Root prefix to make package documentation distribution. Release files,
doxygen source documention, python pydoc documentation, and published
papers are found under DOC_ROOT.

VAR=VAL
The VAR=VAL arguments define additional name-value pairs to be used as working
atat @VAR@ variables for template processing. The VAR name is case insensitive.

See '{self.argv0} --show ref' for referenced variables in template.
""")

  def get_options(self, argv):
    """ Get main options and arguments. """
    self.argv0 = os.path.basename(argv[0])

    self.out.set_prefix(self.argv0)

    # option defaults
    kwargs = {}
    kwargs['color']       = True
    kwargs['debug']       = False
    kwargs['verbose']     = False
    kwargs['images_path'] = None
    kwargs['doxy_index']  = None
    kwargs['pydoc_index'] = None
    kwargs['pub_dir']     = None
    kwargs['rel_files']   = []
    kwargs['show']        = []
    kwargs['atat']        = {}

    shortopts = "?h"
    longopts  = ['help', 'debug', 'doxy-index=', 'images-path=', 'no-color',
                 'pub-dir=', 'pydoc-index=', 'rel-files=', 'show=', 'verbose']
    show_args = ['def', 'ref', 'pre', 'post']

    # parse command-line options
    try:
      try:
        opts, args = getopt.getopt(argv[1:], shortopts, longopts=longopts)
      except getopt.error as msg:
        raise UsageError(msg)
      for opt, optarg in opts:
        if opt in ('-h', '--help', '-?'):
          self.print_help()
          sys.exit(0)
        elif opt in ('--no-color',):
          kwargs['color'] = False
          self.turn_off_color()
        elif opt in ('--doxy-index'):
          kwargs['doxy_index'] = optarg
        elif opt in ('--images-path'):
          kwargs['images_path'] = [p.strip() for p in optarg.split(':')]
        elif opt in ('--pub-dir'):
          kwargs['pub_dir'] = optarg
        elif opt in ('--pydoc-index'):
          kwargs['pydoc_index'] = optarg
        elif opt in ('--rel-files'):
          kwargs['rel_files'] = [f.strip() for f in optarg.split(';')]
        elif opt in ('--show',):
          if optarg == 'all':
              kwargs['show'] = show_args
          elif optarg in show_args and optarg not in kwargs['show']:
            kwargs['show'] += [optarg]
          else:
            raise UsageError(f"'{optarg}': Unknown 'show' option argument.")
        elif opt in ('--debug'):
          kwargs['debug'] = True
        elif opt in ('--verbose'):
          kwargs['verbose'] = True
    except UsageError as err:
      self.print_usage_error(err.msg)
      sys.exit(2)

    # non-nvp arguments
    nargs = []

    # name=value pair regex
    reNvp = re.compile('([a-zA-Z_]\w*)=(.*)')
    
    for arg in args:
      g = reNvp.match(arg)
      if g is not None and len(g.groups()) == 2:
        kwargs['atat'][g[1]] = g[2]
      else:
        nargs.append(arg)

    if len(nargs) < 1:
      self.print_usage_error("No TEMPLATE index.html specified")
      sys.exit(2)
    else:
      kwargs['template'] = nargs[0]

    if len(nargs) < 2:
      self.print_usage_error("No DOC_ROOT path specified")
      sys.exit(2)
    else:
      kwargs['doc_root'] = nargs[1]

    return kwargs

  #--
  def main(self, argv):
    """ main """
    self.kwargs = self.get_options(argv)

    self.debug('kwargs =', self.kwargs)

    self.make_vars()

    if self.kwargs['show']:
      self.show()
    else:
      self.make_html_index()

    return 0

#------------------------------------------------------------------------------
app = HomeMaker()
sys.exit( app.main(sys.argv) )


#/*! \endcond RNMAKE_DOXY */
