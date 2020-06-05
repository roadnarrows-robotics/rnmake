"""
Gums' sumptious recipes.

Author: @PKG_AUTHOR@ 

License: @PKG_LICENSE@
"""

About = """\
Gums has lived a very long life. 29 Snow Moons young. She is a member of the
Clan of the Cave Cricket. Over the years, Gums has curated a long list of
recipes that have provided her clan an enhanced quality of life. Well, at least,
food that didn't kill."""

class GumsRecipe:
  """ Recipe class """
  def __init__(self, ingredients=[], instructions=[]):
    """
    Initializer.

    Parameters:
      ingredients   List of things tossed into the food.
      instrcutions  The step-by-step manual.
    """
    self.ingredients = ingredients
    self.instructions = instructions
