#
# Description:
#   AtAt variable parsing classes.
#
# Author:
#   Robin D. Knight (robin.knight@roadnarrows.com)
#
# Copyright:
#   (C) 2013-2020. RoadNarrows LLC.
#   http://www.roadnarrows.com
#   All Rights Reserved
#
# License:
#   MIT
#

import os
import time
import io
import re

from pprint import pformat

from rnmake.color import ColorfulOutput

# ------------------------------------------------------------------------------
class AtAtError(Exception):
  """ AtAt Exception. """
  def __init__(self, msg, filename=None, line_num=0):
    self.msg = msg
    self.filename = filename
    self.line_num = line_num

  def __str__(self):
    if self.filename:
      if self.line_num > 0:
        return f"{self.filename}[{self.line_num}]: {self.msg}"
      else:
        return f"{self.filename}: {self.msg}"
    else:
      return f"{self.msg}"

# ------------------------------------------------------------------------------
class AtAt:
  """ Replace @variable@ and @variable:format@ tags in file class. """

  # @...@ regex
  _reAtAt = re.compile('@([a-zA-Z_]\w*)@|@([a-zA-Z_]\w*):(.+)@')

  # end of template tag for (debug) printing
  EOT_MARK = '      ~~ end-of-template ~~'

  def __init__(self, out=None):
    """ Initializer. """
    self.out = out
    if not self.out:
      out = color.ColorfulOutput(prefix="AtAt")

    now = time.localtime()
    self._builtin_vars = {
      'THIS_YEAR': repr(now.tm_year),
      'THIS_DATE': "%d.%02d.%02d" % (now.tm_year, now.tm_mon, now.tm_mday),
      'THIS_TIME': "%02d:%02d:%02d" % (now.tm_hour, now.tm_min, now.tm_sec),
      'COPYRIGHT_SPAN': self.copyright_span,
      'TEMPLATE': '',
      'FILENAME': '',
    }
    self._atat_vars = {}
    self._template = None
    self._template_in = []
    self._template_out = []
    self._outfile = None

  @property
  def builtin_vars(self):
    """ Return dictionary of builtin atat variables. """
    return self._builtin_vars

  @property
  def working_vars(self):
    """ Return dictionary of working atat variables. """
    return self._atat_vars

  @property
  def template(self):
    return self._template

  def merge_vars(self, atat_vars={}):
    """ Merge working variables with additional set. """
    self._atat_vars.update(atat_vars)
    self._atat_vars.update(self._builtin_vars)

  def set_var(self, name, val):
    """ Set (new) working variable's value. """
    if name not in self._builtin_vars:
      self._atat_vars[name] = val

  def get_var(self, name):
    """ Get working variable's value. """
    return self._atat_vars.get(name)

  def _update_runtime(self, template, filename=''):
    """ Update runtime determined environment and variables.  """
    self._template = template
    self._template_in = []
    self._template_out = []
    self._outfile = os.path.basename(filename)
    self._builtin_vars['TEMPLATE'] = template
    self._builtin_vars['FILENAME'] = self._outfile
    self._atat_vars['TEMPLATE'] = self._outfile
    self._atat_vars['FILENAME'] = self._outfile

  def preparsed_content(self):
    return self._template_in

  def postparsed_content(self):
    return self._template_out

  def write_atomic(self, fp, val, fmt=None):
    if fmt:
      fp.write(fmt.format(val))
    elif type(val) == str:
      fp.write(val)
    else:
      fp.write(f"{val}")

  def write_list(self, fp, var, val_list, fmt=None):
    for val in val_list:
      self.write_val(fp, var, val, fmt)
      if not fmt:
        fp.write(' ')

  def write_val(self, fp, var, val, fmt=None):
    if val is None:
      pass
    elif callable(val):
      val(fp, var, fmt)
    elif isinstance(val, list) or isinstance(val, tuple):
      self.write_list(fp, var, val, fmt)
    else:
      self.write_atomic(fp, val, fmt)

  def copyright_span(self, fp, var, fmt):
    copy_init = self.get_var('COPYRIGHT_INITIAL')
    this_year = self.get_var('THIS_YEAR')
    if copy_init:
      try:
        y0 = int(copy_init)
        y1 = int(this_year)
      except (ValueError, TypeError):
        fp.write(this_year)
      else:
        if y0 < y1:
          fp.write(f"{y0}-{y1}")
        else:
          fp.write(f"{y1}")
    else:
      fp.write(this_year)

  def one_var_iter(self, fp, var, fmt, vals):
    """
    One variable iterator callable atat function.

    Example use:
      cb = lambda fp, var, fmt: self.one_var_iter(fp, var, fmt, my_vals)
    """
    for val in vals:
      print(f"{fmt}".format(val), file=fp)

  def two_var_iter(self, fp, var, fmt, pairs):
    for val1, val2 in pairs:
      print(f"{fmt}".format(val1, val2), file=fp)

  def three_var_iter(self, fp, var, fmt, triples):
    for val1, val2, val3 in triples:
      print(f"{fmt}".format(val1, val2, val3), file=fp)

  def atat_match(self, match):
    if match.lastindex == 1:
      return (match.group(1), None)
    elif match.lastindex == 3:
      return (match.group(2), match.group(3))
    else:
      return (None, None)

  def is_template_loaded(self):
    return len(self._template_in) > 0

  def is_template_parsed(self):
    return len(self._template_out) > 0

  def load_template(self, template):
    """ Load raw template into memory. """
    self._update_runtime(template)
    try:
      with open(self._template, "r") as f:
        self._template_in = f.readlines()
    except OSError as e:
      raise AtAtError(e.strerror, e.filename)

  def characterize(self):
    """ Characterize the loaded template. """
    if not self.is_template_loaded():
      raise AtAtError("No template loaded.")
    info = []
    line_num = 0
    for line in self._template_in:
      line_num += 1
      m = 0
      for match in AtAt._reAtAt.finditer(line):
        var, fmt = self.atat_match(match)
        if fmt is None:
          fmt = ''
        info += [{'variable': var, 'format': fmt, 'line_num': line_num,
                  'col_start': match.start()+1, 'col_end': match.end()}]
        m = match.end()
    return info

  def parse(self):
    """ Parse in-memory template. """
    if not self.is_template_loaded():
      raise AtAtError("No template loaded.")
    self._template_out = []
    line_num = 0

    with io.StringIO() as ss:
      for line in self._template_in:
        line_num += 1
        m = 0
        for match in AtAt._reAtAt.finditer(line):
          ss.write(line[m:match.start()])
          var, fmt = self.atat_match(match)
          if var in self._atat_vars:
            self.write_val(ss, var, self._atat_vars[var], fmt)
          else:
            self.out.iowarning(var, "Undefined variable",
                               filename=self.template, line_num=line_num)
            ss.write(match.group(0))
          m = match.end()
        if m < len(line):
          ss.write(line[m:])
      self._template_out = ss.getvalue().splitlines(True)
      if self._template_out[-1].strip() == '':
        self._template_out.pop()

  def replace_in_file(self, template, overwrite=True):
    self._update_runtime(template, template)
    filename_tmp = self._template + '.tmp'
    try:
      with open(self._template, 'r') as fin, open(filename_tmp, 'w') as ftmp:
        line_num = 1
        line = fin.readline()
        while line:
          m = 0
          for match in AtAt._reAtAt.finditer(line):
            ftmp.write(line[m:match.start()])
            var, fmt = self.atat_match(match)
            if var in self._atat_vars:
              self.write_val(ftmp, var, self._atat_vars[var], fmt)
            elif var in self.builtin_vars:
              self.write_val(ftmp, var, self.builtin_vars[var], fmt)
            else:
              self.out.iowarning(var, "Undefined variable",
                                 filename=self._template, line_num=line_num)
              ftmp.write(match.group(0))
            m = match.end()
          if m < len(line):
            ftmp.write(line[m:])
          line_num += 1
          line = fin.readline()
      mode = os.stat(self._template).st_mode
      os.chmod(filename_tmp, mode)
    except OSError as e:
      raise AtAtError(e.strerror, e.filename)
    if overwrite:
      try:
        os.rename(filename_tmp, self._template)
        return self._template
      except OSError as e:
        raise AtAtError(e.strerror, e.filename)
    else:
      return filename_tmp

# ------------------------------------------------------------------------------
class AtAtPrettyPrint:
  """ Pretty print AtAt class instance adjunct class. """

  def __init__(self, atat):
    """ Initializer. """
    self.atat = atat

  def show_defined(self, color_var='brown', color_val='lightblue'):
    """ Pretty-print defined atat variables. """
    # test data (uncomment)
    #self.atat.merge_vars({
    #  'Aint':53,
    #  'Fdouble': 45.314159,
    #  'Blist':[0,1,2,3,4,5,6,7,8,9] * 10,
    #  'Ztuple':(99,-99),
    #  'Ucallable': self.atat.one_var_iter})
    self.atat.out.info(f"    Defined Working Variables")
    self.atat.out.cprint(color_var, f"{self.atat.out.ul('Variable')}{' ':<12} ",
                         color_val, f"{self.atat.out.ul('Value')}")
    nvpairs = self.atat.working_vars
    names = list(nvpairs)
    names.sort()
    for n in names:
      v = nvpairs[n]
      if callable(v):
        vstr = v.__name__ + '()'
      elif isinstance(v, list) or isinstance(v, tuple):
        vstr = pformat(v, width=58, compact=True)
        vstr = vstr.split('\n')
      else:
        vstr = str(v)
      # prettyfied iterable 
      if isinstance(vstr, list):
        self.atat.out.cprint(color_var, f"{n:<20} ", color_val, f"{vstr[0]}")
        for l in vstr[1:]:
          self.atat.out.cprint(color_val, f"{' ':<20} {l}")
      # atomic
      else:
        self.atat.out.cprint(color_var, f"{n:<20} ", color_val, f"{vstr}")

  def show_referenced(self, color_num='darkgray', color_var='brown',
                            color_fmt='lightblue'):
    """ Pretty-print template referenced atat variables. """
    if not self.atat.is_template_loaded():
      self.atat.out.error("No template loaded")
      return
    info = self.atat.characterize()
    self.atat.out.info(f"    References in {self.atat.template}")
    self.atat.out.cprint(color_num, f"{self.atat.out.ul('Line')} ",
                    color_num, f"{self.atat.out.ul('Columns')} ",
                    color_var, f"{self.atat.out.ul('Variable')}",
                    'normal', f"{' ':<12} ",
                    color_fmt, f"{self.atat.out.ul('Format String')}")
    for i in info:
      self.atat.out.cprint(color_num, f"{i['line_num']:>4} ",
                           color_num, f"{i['col_start']:>3}-{i['col_end']:<3} ",
                           color_var, f"{i['variable']:<20} ",
                           color_fmt, f"{i['format']}")

  def show_preparsed(self, color_txt='green'):
    """ Pretty-print pre-parsed template. """
    if not self.atat.is_template_loaded():
      self.atat.out.error("No template loaded")
      return
    self.atat.out.info(f"    Pre-parsed {self.atat.template}")
    self.atat.out.hr(color='darkgray')
    for line in self.atat.preparsed_content():
      self.atat.out.cprint(color_txt, line, end='')
    self.atat.out.hr(color='darkgray')

  def show_postparsed(self, color_txt='green'):
    """ Pretty-print post-parsed template. """
    if not self.atat.is_template_loaded():
      self.atat.out.error("No template loaded")
      return
    if not self.atat.is_template_parsed():
      self.atat.parse()
    self.atat.out.info(f"    Post-parsed {self.atat.template}")
    self.atat.out.hr(color='darkgray')
    for line in self.atat.postparsed_content():
      self.atat.out.cprint('info', line, end='')
    self.atat.out.hr(color='darkgray')
