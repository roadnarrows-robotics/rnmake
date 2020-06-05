"""
Pleistocene South American flora.

Author: @PKG_AUTHOR@ 

License: @PKG_LICENSE@
"""

from @PKG_NAME@.common.species import Species
from @PKG_NAME@.common.wildlife import Wildlife

def populate():
  """ Populate wildlife. """
  life = Wildlife('flora', 'South America', 11.7, 2_580, gts='Pliestocene')

  life.add(Species('mays', 'Zea', common='teosinte',
                   appearance=10_000, extinction=0,
                   distribution='Mesoamerica'))
  life.add(Species('quinoa', 'Chenopodium', common='quinoa',
                   appearance=10_000, extinction=0,
                   distribution='Andes'))
  life.add(Species('cruentus', 'Amaranthus', common='amaranth',
                   appearance=10_000, extinction=0,
                   distribution='Central America'))
  life.add(Species('cupressoides', 'Fitzroya', common='Patagonian cypress',
                   appearance=10_000, extinction=0,
                   distribution='Chile'))

  return life
