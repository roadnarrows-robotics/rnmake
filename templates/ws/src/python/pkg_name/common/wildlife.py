"""
A collection of interacting organisms within a geographic region and timescale.

Author: @PKG_AUTHOR@ 

License: @PKG_LICENSE@
"""

from @PKG_NAME@.common.species import Species

class Wildlife:
  """ Wildlife class """

  def __init__(self, tag, region, youngest, oldest, gts=None):
    """
    Initializer

    Parameters:
      tag       Wildlife tag identifier (e.g. flora, fauna, pop-345).
      region    Geographic region.
      youngest  Youngest endpoint in timescale, thousands year ago.
      oldest    Oldest endpoint in timescale, thousands year ago.
      gts       Geologic time scale (e.g. Paleogene, Pliocene, Tortonian).
    """
    self._tag       = tag
    self._region    = region
    self._youngest  = youngest
    self._oldest    = oldest
    self._gts       = gts
    self.species    = {}

  def __repr__(self):
    """ Return repr(self). """
    return  f"{self.__module__}.{self.__class__.__name__}" \
            f"({self._tag}, {self._region}" \
            f"{self._youngest}, {self._oldest})"

  def __str__(self):
    """ Return str(self). """
    return self._tag

  def __getitem__(self, k):
    return self.species[k]

  def __delitem__(self, k):
    del self.species[k]

  def __iter__(self):
    return iter(self.species.values())

  @property
  def tag(self):
    return self._tag

  @property
  def geographic_region(self):
    """ Return species geographic range. """
    return self._region

  @property
  def geologic_timescale(self):
    return self._gts

  def eco_region(self):
    """ Return eco-region geographic location and geologic timescale. """
    if self._gts:
      name = f"{self._gts} {self._region}"
    else:
      name = f"{self._region}"
    return f"{name} {self._youngest:.3f}-{self._oldest:.3f} kya"

  def timescale(self):
    """ Return 2-tuple timescale. """
    return (self._youngest, self._oldest)

  def add(self, species):
    self.species[species.binomial_name] = species

  def richness(self):
    """ Return all wildlife species binomial names. """
    return list(self.species.keys())

  def find(self, prop, val):
    """
    Find the first species in wildlife with the property of value.

    Parameters:
      prop  Property. One of 'species' 'genus' 'common' 'distribution'
      val   Value of property to find.

    Returns:
      Species on success, None otherwise.
    """
    attr = {'species':      'species',
            'genus':        'genus', 
            'common':       'common_name', 
            'distribution': 'geographic_distribution', } 

    for sp in self.species.values():
      if getattr(sp, attr[prop]) == val:
        return sp
    return None

  def match_genus(self, genus):
    """
    Find all species within the given genus.

    Parameters:
      genus   Genus generic name.

    Return:
      Return list of matched species.
    """
    genus = genus.capitalize()
    matches = []
    for sp in self.species.values():
      if sp.genus == genus:
        matches.append(sp)
    return matches

  def match_earlier(self, kya):
    """
    Find all species the lived before the given time.

    Parameters:
      kya   Thousands years ago

    Return:
      Return list of matched species.
    """
    matches = []
    for sp in self.species.values():
      if sp.first_recorded >= kya:
        matches.append(sp)
    return matches

  def match_later(self, kya):
    """
    Find all species that lived after the given time.

    Parameters:
      kya   Thousands years ago

    Return:
      Return list of matched species.
    """
    matches = []
    for sp in self.species.values():
      if sp.last_recorded <= kya:
        matches.append(sp)
    return matches

  def match_between(self, youngest, oldest):
    """
    Find all species the lived sometime between the given time backet.

    Parameters:
      youngest  Youngest time, thousands years ago
      oldest    Oldest time, thousands years ago

    Return:
      Return list of matched species.
    """
    seta = set(self.match_later(oldest))
    setb = set(self.match_earlier(youngest))
    return list(seta & setb)
