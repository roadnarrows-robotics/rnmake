#!/usr/bin/env python3

import time

# test swigged python modules to libpleistocene.so c library
import @PKG_NAME@.pleistocene.stone_tools as tech
import @PKG_NAME@.pleistocene.fire as fire

# test intact ecosystem with internal imports to common module
import @PKG_NAME@.pleistocene.sa_fauna as sa_fauna
import @PKG_NAME@.pleistocene.sa_flora as sa_flora

# straight up easy-peasy import
from @PKG_NAME@.whatever.charred_mammoth import recipe

def make_bold(s):
  """ Cheap bold font by unicode 'font variant' decomposition. """
  bold_A = 0x1d5d4
  bold_a = bold_A + 26
  uni = ''
  for c in s:
    uc = ord(c) - ord('A')    # upper case block
    lc = ord(c) - ord('a')    # lower case block
    if uc >= 0 and uc < 26:
      uni += chr(bold_A+uc)
    elif lc >= 0 and lc < 26:
      uni += chr(bold_a+lc)
    else:
      uni += c
  return uni

def make_italic(s):
  """ Cheap italic font by unicode 'font variant' decomposition. """
  #ital_A = 0x1d434     # alternative block
  ital_A = 0x1d608
  ital_a = ital_A + 26
  ital_h = 0x210e
  uni = ''
  for c in s:
    uc = ord(c) - ord('A')    # upper case block
    lc = ord(c) - ord('a')    # lower case block
    if uc >= 0 and uc < 26:
      uni += chr(ital_A+uc)
    elif c == 'h':            # 'h' is special planck constante
      uni += chr(ital_h)
    elif lc >= 0 and lc < 26:
      uni += chr(ital_a+lc)
    else:
      uni += c
  return uni

def teleprompter(text, wpm=200, pause=0, font='normal'):
  """
  Teleprompter. (Now oralize it.)

  Parameters:
    wpm     Read or spoken words per minute.
    pause   Pause for dramatic effect.
  """
  if isinstance(text, str):
    text = text.split('\n')
  for line in text:
    wps = wpm / 60            # words/second
    w = (len(line) + 1) / 5   # number of words (assume 5 letters/word average)
    if font == 'bold':
      line = make_bold(line)
    elif font == 'italic':
      line = make_italic(line)
    print(line)
    time.sleep(w / wps)
  if pause > 0:
    time.sleep(pause)

# words/minute
wpm=200

# time between sections
t_sect = 0.5

teleprompter("A Tail of Two Tusks\n", wpm=wpm, pause=t_sect, font='bold')

teleprompter("""\
It was the best of thighs.
It was the worst of thighs.
""", wpm=wpm, pause=t_sect, font='italic')

teleprompter("""\
Thag! Thag! 
Ug?
We found dead two tusks.
Where?
By river.
Any toothies lurking?
No see none.
""", wpm=wpm, pause=t_sect)

# second test of c library interface
teleprompter("""\
Ogg, Old Wink, you come with me.
You too Bitey.
Eet Bugs, go to Gums get 'how to cook'
Run!
""", wpm=wpm, pause=t_sect)

teleprompter("(after scenic roadtrip to river)\n", wpm=wpm)

teleprompter(f"""\
There, two tusks!
Stinky.
That back leg gud nough
Ogg, Bitey start cutting with {tech.name_of_stone_tool(tech.STONE_TOOL_BLADE)}.
What that?
Rocks like {tech.desc_of_stone_tool(tech.STONE_TOOL_BLADE)}.
""", wpm=wpm, pause=t_sect)

teleprompter("""\
It was the epoch of harsh obscene.
It was the epoch of Pleistocene.
""", wpm=wpm, pause=t_sect, font='italic')

teleprompter("""\
As clan work, Old Wink gazes over valley.
He see much. Ponder much.
""", wpm=wpm, pause=t_sect)

# test of another module
fauna = sa_fauna.populate()

teleprompter(fauna.richness(), wpm=wpm, pause=t_sect)

teleprompter("""
Bitey. Run. Get clan ready for feast.
""", wpm=wpm)

teleprompter("(back at the cave)\n", wpm=wpm)

# test of another module
flora = sa_flora.populate()

teleprompter(f"""\
Eet Bugs, how we cook?
Need grubs and amaranth.
Old Old Wink, make fire.
Izz go get handfuls {fauna.find('genus', 'Rhynchophorus').binomial_name}.
Mook, {flora.find('common', 'amaranth').binomial_name}.
""", wpm=wpm, pause=t_sect)

teleprompter(f"""\
Old Old Wink. Fire {fire.me_get_fire(fire.FIRE_WAY_MAGIC)} don't know how.
No Wink, fire {fire.me_get_fire(fire.FIRE_WAY_HANDS)} don't work, remember?
Fire {fire.me_get_fire(fire.FIRE_WAY_VOLCANO)} too big time!
Yes! Fire {fire.me_get_fire(fire.FIRE_WAY_STICKS)}. Rub Old Old Wink. Rub!
""", wpm=wpm, pause=t_sect)

teleprompter(f"""\
Me Nogga Ya. I cook.
Bring me ingredients.
Now I do this.
""", wpm=wpm, pause=t_sect)

teleprompter(recipe.instructions, wpm=wpm, pause=t_sect)

teleprompter("""
We ate everything before us.
We left nothing before us.
""", wpm=wpm, pause=t_sect, font='italic')

teleprompter("Ooga Ooga", wpm=wpm)
