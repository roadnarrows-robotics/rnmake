"""
A Living organism.

Author: @PKG_AUTHOR@ 

License: @PKG_LICENSE@
"""

class Species:
  """ Species class """

  def __init__(self, specific, genus, common=None,
                     appearance=0.0, extinction=0.0, distribution='Earth'):
    """
    Initializer

    Parameters:
      _specific       Species specific scientific name.
      _genus          Species generic genus scientific name.
      _common         Species common name.
      _appearance     Species (estimated) first appearance, thousands year ago.
      _extinction     Species (estimated) extinction, thousands year ago.
                      Set to zero if species still present.
      _distribution   Geographic region found.
    """
    self._specific      = specific.lower()
    self._genus         = genus.capitalize()
    self._common        = common
    self._appearance    = appearance
    self._extinction    = extinction
    self._distribution  = distribution

  def __repr__(self):
    """ Return repr(self). """
    return  f"{self.__module__}.{self.__class__.__name__}" \
            f"({self._specific}, {self._genus})"

  def __str__(self):
    """ Return str(self). """
    return self.binomial_name

  @property
  def binomial_name(self):
    """ Return species binomial name. """
    return f"{self._genus} {self._specific}"

  @property
  def binomial_short(self):
    """ Return species short binomial name. """
    return f"{self._genus[0]}. {self._specific}"

  @property
  def species(self):
    """ Return species specific scientific name. """
    return self._specific

  @property
  def genus(self):
    """ Return species genus scientific name. """
    return self._genus

  @property
  def common_name(self):
    """ Return species common name. """
    return self._common
  
  @property
  def first_recorded(self):
    """ Return species first (oldest) evidence in record (kya). """
    return self._appearance
  
  @property
  def last_recorded(self):
    """ Return species last (youngest) evidence in record (kya). """
    return self._extinction
  
  @property
  def geographic_distribution(self):
    """ Return species geographic range. """
    return self._distribution

  def presence_in_record(self):
    """ Return 2-tuple of species time span. """
    return (self._appearance, self._extinction)
    
  def is_extinct(self):
    """ Return True or False. """
    return self._extinction > 0.0
