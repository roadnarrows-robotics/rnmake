#!/usr/bin/env python3
#
# File:
#   pydocmk.py
#
# Usage:
#   pydocmk.py [OPTIONS] [VAR=VAL [VAR=VAL...]] PYDOC_ROOT SETUP_PY
#   pydocmk.py --help
#
# Description:
#   Make python documentation for python [sub]package.
#
# /*! \file */
# /*! \cond RNMAKE_DOXY*/

import sys
import os
import time
import importlib
import subprocess
import shutil
import re
import pydoc
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

# pydoc command in list format
PyDocCmd = ['pydoc3', '-w']

# image relative path directory url component
UrlImagePath = 'images'

# parent page relative url
UrlParentPage = '../index.html'

# license (eula) file
UrlLicense = '../LICENSE'

# default pydoc information (better to define in setup script)
PyDocInfoDft = {
  'org':            None,
  'org_fq':         None,
  'org_abbrev':     None,
  'favicon':        None,
  'logo':           None,
  'template':       '',
  'images_src_dir': '',
}

# template @variable@ substitution names to values dictionary basic set
AtAtBasicSet = {
  'author':         None,
  'description':    None,
  'email':          None,
  'favicon':        None,
  'license':        'AS-IS',
  'mod_href_iter':  None,
  'mod_ul_iter':    None,
  'image_path':     UrlImagePath,
  'keywords':       None,
  'license_file':   UrlLicense,
  'long_desc':      None,
  'org':            None,
  'org_abbrev':     None,
  'org_fq':         None,
  'org_logo':       None,
  'org_url':        None,
  'parent_page':    UrlParentPage,
  'pkg_name':       None,
  'pkg_ver':        None,
}


# -----------------------------------------------------------------------------
class UsageError(Exception):
  """ Command-Line Options UsageError Exception Class. """
  def __init__(self, msg):
    self.msg = msg

# -----------------------------------------------------------------------------
class PyDocMaker:
  """ The pydoc maker class. """

  def __init__(self):
    self.out            = ColorfulOutput()
    self.atat           = AtAt(out=self.out)
    self.pydoc_info     = {}
    self.pkg_info       = {}
    self.py_mod_list    = []
    self.py_file_list   = []
    self.paths          = {}
    self.html_vars      = {}

  def run_setup(self, option):
    """ Run the setup script to get information (slow). """
    completed = subprocess.run([self.kwargs['setup'], '--'+option],
                                stdout=subprocess.PIPE, encoding='utf-8')
    o = completed.stdout
    if o[-1] == '\n':
      o = o[:-1]
    return o

  def import_setup(self):
    """ Import the setup python script to access information (much faster). """
    setup_py = self.kwargs['setup']
    setup_module = os.path.splitext(os.path.basename(setup_py))[0]
    dname = os.path.dirname(setup_py)
    if dname:
      sys.path = [dname] + sys.path
    else:
      sys.path = ['.'] + sys.path
    try:
      setup = importlib.import_module(setup_module)
    except ImportError:
      self.fatal(8, setup_module, "Cannot import")
    return setup

  def get_pydoc_info(self, setup):
    if 'PyDocInfo' in dir(setup):
      self.pydoc_info = setup.PyDocInfo.copy()
    else:
      self.pydoc_info = PyDocInfoDft.copy()
    return self.pydoc_info

  def make_vars(self):
    self.verbose(f"Making pydoc environment from {self.kwargs['setup']}")
    setup = self.import_setup()

    self.pydoc_info = self.get_pydoc_info(setup)

    self.debug("pydoc_info =", self.pydoc_info)

    try:
      self.pkg_info = setup.PkgInfo.copy()
    except AttributeError:
      self.fatal(8, f"'PkgInfo' not found in {setup.__name__}")

    self.debug("pkg_info =", self.pkg_info)

    # input/output paths
    self.paths['template'] = self.kwargs.get('template',
                                             self.pydoc_info.get('template'))
    self.paths['org_logo_src'] = self.kwargs['atat'].get('org_logo',
                                             self.pydoc_info.get('logo'))
    self.paths['favicon_src'] = self.kwargs['atat'].get('favicon',
                                             self.pydoc_info.get('favicon'))
    self.paths['pydoc_root'] = self.kwargs['pydoc_root']
    self.paths['pydoc_img_dir'] = os.path.join(self.paths['pydoc_root'],
                                               UrlImagePath)
    self.paths['pydoc_html_dir'] = os.path.join(self.paths['pydoc_root'],
                                                'html')

    self.debug('paths =', self.paths)

    # template variables
    self.make_atat_vars()

    self.verbose('')

  def make_atat_vars(self):
    """ Make and set all working atat varibles for template processing. """
    # atat variable dictionary 
    atatvar = AtAtBasicSet.copy()

    # atat variables from pydoc information
    atatvar['org']          = self.pydoc_info['org']
    atatvar['org_fq']       = self.pydoc_info['org_fq']
    atatvar['org_abbrev']   = self.pydoc_info['org_abbrev']
    atatvar['org_logo']     = self.pydoc_info['logo']
    atatvar['favicon']      = self.pydoc_info['favicon']

    # atat variables from setup package information
    atatvar['author']       = self.pkg_info['author']
    atatvar['description']  = self.pkg_info['description']
    atatvar['email']        = self.pkg_info['author_email']
    atatvar['keywords']     = self.pkg_info['keywords']
    atatvar['license']      = self.pkg_info['license']
    atatvar['long_desc']    = self.pkg_info['long_description']
    atatvar['org_url']      = self.pkg_info['url']
    atatvar['pkg_name']     = self.pkg_info['name']
    atatvar['pkg_ver']      = self.pkg_info['version']

    # command-line overrides
    atatvar.update(self.kwargs['atat'])

    # final atat variable massaging
    atatvar['mod_href_iter'] = self.module_href_iter
    atatvar['mod_ul_iter']   = self.module_ul_iter
    if not atatvar['image_path']:
      atatvar['image_path'] = UrlImagePath
    if not atatvar['parent_page']:
      atatvar['parent_page'] = UrlParentPage
    if not atatvar['license_file']:
      atatvar['license_file']  = UrlLicense
    if atatvar['description']:
      atatvar['description'] = atatvar['description'].replace('\n', '<br>')
    if atatvar['long_desc']:
      atatvar['long_desc'] = atatvar['long_desc'].replace('\n', '<br>')
    for k in ['org_logo', 'favicon']:
      if atatvar[k]:
        atatvar[k] = os.path.basename(atatvar[k])

    # upper case names and remove undef'd
    for k,v in atatvar.items():
      if v is not None:
        self.html_vars[k.upper()] = v

    self.atat.merge_vars(self.html_vars)

    self.debug("html_vars =", self.html_vars)

  def make_dirs(self, *dirnames):
    self.verbose(f"Making pydoc directories {self.paths['pydoc_root']}")
    for d in dirnames:
      if not os.path.exists(d):
        os.makedirs(d, mode=0o775)
    self.verbose('')

  def copy_images(self):
    dstdir = self.paths['pydoc_img_dir']
    self.verbose(f"Copying image files to {dstdir}")
    for imgtag in ['favicon_src', 'org_logo_src']:
      src = self.paths[imgtag]
      try:
        shutil.copy(src, dstdir)
        self.debug(f"copied {src}")
      except OSError as e:
        self.out.iowarning(e.strerror, filename=e.filename)
    self.verbose('')
  
  def get_python_file_list(self, pkg, pure=True):
      pylist = []
      for root, dirs, files in os.walk(pkg):
        if root.find('__pycache__') >= 0:
          continue
        for f in files:
          mod, ext = os.path.splitext(f)
          if (not pure or mod[0] != '_') and ext == '.py':
            pylist += [os.path.join(root, f)]
      return pylist

  def get_python_module_list(self, pkg):
      modlist = []
      for root, dirs, files in os.walk(pkg):
        rootmod = root.replace(os.sep, '.')
        if rootmod.find('__pycache__') >= 0:
          continue
        modlist += [rootmod]
        for f in files:
          mod, ext = os.path.splitext(f)
          if mod[0] != '_' and ext == '.py':
            modlist += [rootmod + '.' + mod]
      return modlist

  def make_html_batch_doc(self, mod_batch):
    if not mod_batch or len(mod_batch) == 0:
      return 0
    batch = []
    for mod in mod_batch:
      batch += [mod]
    self.debug('pydoc module batch =', batch)
    completed = subprocess.run(PyDocCmd + batch) 
    return completed.returncode

  def make_html_doc(self, mod):
    if not mod:
      return 0
    self.debug('module =', batch)
    completed = subprocess.run(PyDocCmd + [mod]) 
    return completed.returncode

  def make_html_pkg_docs(self):
    self.verbose(f"Making pydoc {self.pkg_info['name']} package documentation")

    # fixup python search path (assumes python packages are located below here)
    sys.path = [os.getcwd()] + sys.path

    self.py_mod_list = []

    # packages list (includes subpackages)
    for pkg in self.pkg_info['packages']:
      # exclude subpackages
      if pkg.find('.') >= 0:
        continue
      self.py_mod_list += self.get_python_module_list(pkg)

    self.debug('py_mod_list =', self.py_mod_list)

    # pydoc outputs html files in current working directory
    os.chdir(self.paths['pydoc_html_dir'])

    # make pydoc html files
    batch_size = 4
    i = 0
    while i < len(self.py_mod_list):
      self.make_html_batch_doc(self.py_mod_list[i:i+batch_size])
      i += batch_size

    self.verbose('')
  
  def module_href_iter(self, fp, var, fmt):
    for mod in self.py_mod_list:
      print(f"{fmt}".format(mod, mod), file=fp)

  def module_ul_iter(self, fp, var, fmt):
    for mod in self.py_mod_list:
      print(f"{fmt}".format(mod), file=fp)

  def make_html_index(self):
    if not self.paths['template']:
      self.verbose("no template file - skipping")
      return
    html_index = os.path.join(self.paths['pydoc_root'], 'index.html')
    self.verbose(f"Making html index {html_index}.")
    self.verbose(f"parsing template {self.paths['template']}")
    postfile = self.atat.replace_in_file(self.paths['template'], False)
    self.verbose("moving to index.html")
    shutil.move(postfile, html_index)
    self.verbose('')

  def run(self):
    self.make_dirs(self.paths['pydoc_root'],
                   self.paths['pydoc_img_dir'],
                   self.paths['pydoc_html_dir'])
    self.copy_images()
    self.make_html_pkg_docs()
    self.make_html_index()

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

    if self.kwargs['show'] and not self.paths['template']:
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
Usage: {self.argv0} [OPTIONS] [VAR=VAL [VAR=VAL...]] PYDOC_ROOT SETUP_PY
       {self.argv0} --help

Generate pydoc html source documentation for the set of python packages
defined in SETUP_PY. The documentation will be created under the
PYDOC_ROOT path directory.

Options:
      --debug           Enable debugging.

      --images-dir=DIR  Images source directory. Both the logo and favicon must
                        must be found here.

      --no-color        Disable color output.

      --parent-page=URL Parent URL of generated pydoc index.html.
                        Default: {UrlParentPage}

      --show=WHAT       Show WHAT to stdout. The show option disables any
                        file updates. May be iterated. WHAT is one of:
                          all   Show all WHATs.
                          def   Show defined atat variables.
                          ref   Show atat variables referenced in template.
                          pre   Show pre-parsed template contents.
                          post  Show post-parsed template contents.
 
      --template=FILE   HTML index.html template. If unspecified, then no
                        index.html is generated.

      --verbose         Print verbose status messages.
                        Default: False
  
  -h, --help            Display this help and exit.

Description:
PYDOC_ROOT
Root prefix to make pydoc related documention for distribution.
  PYDOC_ROOT/
    html/
    images/
    index.html

SETUP__PY
The SETUP_PY (typically ./setup.py) conforms to the setuptools package.
It is imported to collect pydoc and package information for the {PyDocCmd[0]}
utilitiy.

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
    kwargs['color']   = True
    kwargs['debug']   = False
    kwargs['verbose'] = False
    kwargs['show']    = []
    kwargs['atat']    = {}

    shortopts = "?h"
    longopts  = ['help', 'images-src-dir=', 'no-color',
                 'template=', 'show=', 'debug', 'verbose']
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
        elif opt in ('--no-color'):
          kwargs['color'] = False
          self.turn_off_color()
        elif opt in ('--images-src-dir'):
          kwargs['images_src_dir'] = optarg
        elif opt in ('--template'):
          kwargs['template'] = optarg
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
      self.print_usage_error("No PYDOC_ROOT path specified")
      sys.exit(2)
    else:
      kwargs['pydoc_root'] = nargs[0]

    if len(nargs) < 2:
      self.print_usage_error("No input setup.py file specified")
      sys.exit(2)
    else:
      kwargs['setup'] = nargs[1]

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
      self.run()

    return 0


# -----------------------------------------------------------------------------
app = PyDocMaker()
sys.exit( app.main(sys.argv) )


#/*! \endcond RNMAKE_DOXY */
