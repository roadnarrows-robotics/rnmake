#
# Description:
#   Color I/O classes.
#
# Author:
#   Robin D. Knight (robin.knight@roadnarrows.com)
#
# Copyright:
#   (C) 2013-2020. RoadNarrows LLC.
#   http://www.roadnarrows.com
#   All Rights Reserved
#
# \LegalBegin
# \LegalEnd
#

import os
import sys
from pprint import pprint

class ColorfulOutput(dict):
  """ Simple, git 'er done, terminal color output class. """

  # pre and post color sequences
  ANSI_COLOR_PRE    = '\033['
  ANSI_COLOR_POST   = 'm'
  SCREEN_COLOR_PRE  = '\001'
  SCREEN_COLOR_POST = '\002'

  COLOR_TEMPLATES = (
    ("black"       , "0;30"),
    ("red"         , "0;31"),
    ("green"       , "0;32"),
    ("brown"       , "0;33"),
    ("blue"        , "0;34"),
    ("purple"      , "0;35"),
    ("cyan"        , "0;36"),
    ("lightgray"   , "0;37"),
    ("darkgray"    , "1;30"),
    ("lightred"    , "1;31"),
    ("lightgreen"  , "1;32"),
    ("yellow"      , "1;33"),
    ("lightblue"   , "1;34"),
    ("lightpurple" , "1;35"),
    ("lightcyan"   , "1;36"),
    ("white"       , "1;37"),
    ("normal"      , "0"),
  )

  NO_COLOR = ''

  def __init__(self, prefix=''):
    """
    Initializer.

    Parameters:
      prefix    Notifier string prefix.
    """
    self._prefix      = str(prefix)
    self._bu          = {}
    self._color_avail = False
    self._coloring    = False
    self.termcolors()
    self.default_synonyms()

  def termcolors(self):
    """ Fixed color escape sequences based on terminal type. """
    term = os.environ.get('TERM')
    if term in ('linux', 'screen', 'screen-256color',
                'screen-bce', 'screen.xterm-256color'):
      fmt = f"{ColorfulOutput.SCREEN_COLOR_PRE}"\
            f"{ColorfulOutput.ANSI_COLOR_PRE}"\
            "{}"\
            f"{ColorfulOutput.ANSI_COLOR_POST}"\
            f"{ColorfulOutput.SCREEN_COLOR_POST}"
      self.update(dict([(k, fmt.format(v)) for k,v in self.COLOR_TEMPLATES]))
      self._color_avail = True
      self._coloring = True
    elif term in ('xterm', 'xterm-color', 'xterm-256color'):
      fmt = f"{ColorfulOutput.ANSI_COLOR_PRE}"\
            "{}"\
            f"{ColorfulOutput.ANSI_COLOR_POST}"
      self.update(dict([(k, fmt.format(v)) for k,v in self.COLOR_TEMPLATES]))
      self._color_avail = True
      self._coloring = True
    else:
      self.update(dict([(k, NO_COLOR) for k,v in self.COLOR_TEMPLATES]))
      self._color_avail = False
      self._coloring = False
    
  def default_synonyms(self):
    """ Set default color synonyms. """
    self.synonym('darkgray',    'debug') 
    self.synonym('green',       'info') 
    self.synonym('brown',       'warn')
    self.synonym('lightred',    'error')
    self.synonym('lightpurple', 'crit')
    self.synonym('lightpurple', 'fatal')
    self.synonym('green',       'banner')
    self.synonym('green',       'num')
    self.synonym('green',       'premsg')
    self.synonym('lightblue',   'sep')

  def enable_color(self):
    """ Enable color output if available. """
    if self._color_avail and not self._coloring:
      self.update(self._bu)
      self._bu.clear()
      self._coloring = True

  def disable_color(self):
    """ Disable color output. """
    if self._coloring:
      self._bu.update(self)
      for k in list(self):
        self[k] = ColorfulOutput.NO_COLOR
      self._coloring = False

  def is_color_available(self):
    """ Returns True if terminal supports color, False otherwise. """
    return self._color_avail

  def is_coloring(self):
    """ Returns True if color output enabled, False otherwise. """
    return self._coloring

  def synonym(self, color, syn):
    """
    Set a synonum of a name of a color.

    Parameters:
      color   Color name.
      syn     New synonym.
    """
    self[syn] = self[color]

  def set_prefix(self, prefix):
    self._prefix = str(prefix)

  def debug(self, what, *objs):
    """ Debug print objects. """
    self.cprint('lightgray', 'DBG:', 'lightgray', what)
    self.start_color('debug')
    for obj in objs:
      pprint(obj)
    self.end_color()

  def info(self, *args):
    """ Show information message. """
    self.cprint('info', ' '.join([f"{a}" for a in args]))

  def warning(self, *args):
    """ Show warning message. """
    self.iowarning(*args)

  def error(self, *args):
    """ Show error message. """
    self.ioerror(*args)

  def fatal(self, *args):
    """ Show fatal message. """
    self.iofatal(*args)

  def iowarning(self, *args, filename=None, line_num=0):
    """
    Print I/O warning message.

    Parameters:
      *args     Iterable warning message arguments.
      filename  Optional filename associated with I/O.
      line_num  Optional line number of filename.
    """
    self._ioprint('warn', 'Warning', filename, line_num, *args)

  def ioerror(self, *args, filename=None, line_num=0):
    """
    Print I/O error message.

    Parameters:
      *args     Iterable warning message arguments.
      filename  Optional filename associated with I/O.
      line_num  Optional line number of filename.
    """
    self._ioprint('error', 'Error', filename, line_num, *args)

  def iofatal(self, *args, filename=None, line_num=0):
    """
    Print I/O fatal message.

    Parameters:
      *args     Iterable warning message arguments.
      filename  Optional filename associated with I/O.
      line_num  Optional line number of filename.
    """
    self._ioprint('fatal', 'Fatal', filename, line_num, *args)

  def _ioprint(self, tag, level, filename, line_num, *args):
    msg = ': '.join([f"{a}" for a in args])
    self.cprint('premsg', f"{self._prefix}", 'sep', ': ', end='')
    if filename:
      self.cprint('premsg', f"{filename}", end='')
      if line_num > 0:
        self.cprint('sep', ':', 'num', f"{line_num}", end='')
      self.cprint('sep', ': ', end='')
    self.cprint(tag, f"{level}", 'sep', ': ', tag, msg)

  def cprint(self, *args, **kwargs):
    """
    Color print message sequence.

    Note: Not all print_function imports support the flush keyword, so
          this routine uses sys.stdout flush.

    Parameters:
      args    Iterable object of a sequence of color,message pairs.
      kwargs  Keyword arguments to Python3 print function.
    """
    concat = ''
    for i in range(0,len(args),2):
      concat += "{}{}{}".format(self[args[i]], args[i+1], self['normal'])
    flush = kwargs.pop('flush', False)
    print("{}".format(concat), **kwargs)
    if flush:
      sys.stdout.flush()

  def start_color(self, tag):
    """
    Start an output block with the given color. Terminate with end_color().

    Parameters:
      tag     Color name or synonym.
    """
    print(self[tag], end='')

  def end_color(self):
    """ End current color settings and return to default terminal color. """
    print(self['normal'], end='')

  def ul(self, s):
    """ Underline s with unicode combining diacritic. """
    t = ''
    for c in s:
      t += c
      t += '\u0332'
    return t

  def hr(self, n=80, dline=False, color='normal'):
    """
    Output horizontal rule with unicode line code.

    Parameters:
      n       Length of rule in characters.
      dline   Create double line. Default: single.
      color   Color (synonym) of rule.
    """
    if dline:
      line = '\u2550' * n
    else:
      line = '\u2500' * n
    self.cprint(color, line)
