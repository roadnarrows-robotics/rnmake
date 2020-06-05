"""
Pleistocene South American fauna.

Author: @PKG_AUTHOR@ 

License: @PKG_LICENSE@
"""

from @PKG_NAME@.common.species import Species
from @PKG_NAME@.common.wildlife import Wildlife

def populate():
  """ Populate wildlife. """
  life = Wildlife('fauna', 'South America', 11.7, 2_580, gts='Pliestocene')

  life.add(Species('clavipes', 'Glyptodon', common='glyptodont',
                   appearance=3_500, extinction=4,
                   distribution='Brazil'))
  life.add(Species('clavicaudatus', 'Doedicurus', common='glyptodont',
                   appearance=2_000, extinction=8,
                   distribution='Patagonia'))
  life.add(Species('principale', 'Hippidion', common='little horse',
                   appearance=2_500, extinction=8,
                   distribution='Bolivia'))
  life.add(Species('platensis', 'Toxodon', common='toxodon',
                   appearance=23_000, extinction=11,
                   distribution='South America'))
  life.add(Species('hydrochaeris', 'Hydrochoerus', common='capybara',
                   appearance=1_000, extinction=0,
                   distribution='South America'))
  life.add(Species('lucifer', 'Cheracebus', common='Lucifer titi',
                   appearance=1_000, extinction=0,
                   distribution='South America'))
  life.add(Species('medemi', 'Cheracebus', common='Colombian black-handed titi',
                   appearance=1_000, extinction=0,
                   distribution='Colombia'))
  life.add(Species('venezuelensis', 'Caiman', common='caiman',
                   appearance=5_000, extinction=15,
                   distribution='South America'))
  life.add(Species('longissimus', 'Phorusrhacidae', common='terror bird',
                   appearance=62_000, extinction=1_800,
                   distribution='South America'))
  life.add(Species('hispidus', 'Rhinotermes', common='termite',
                   appearance=150_000, extinction=0,
                   distribution='South America'))
  life.add(Species('palmarum', 'Rhynchophorus', common='palm weevil larvae',
                   appearance=100_000, extinction=0,
                   distribution='Peru'))

  return life
