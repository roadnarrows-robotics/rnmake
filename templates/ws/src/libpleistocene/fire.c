/*! \file
 *
 * \brief A library of stone tools.
 *
 * \pkgfile{fire.c}
 * \pkgcomponent{Library,libpleistocene}
 * \author @PKG_AUTHOR@
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#include <stddef.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#include "@PKG_NAME@/fire.h"

typedef struct
{
  bool        isgood;
  const char *metellhow;
} fire_ways_t;

static fire_ways_t Fires[] =
{
  {false, "with harnessed nuclear power"},
  {false, "by waiting for lightning strike"},
  {true,  "by rubbing two sticks together"},
  {false, "by rubbing hands"},
  {false, "from volcano burp"},
  {true,  "by thrusting lit bunny butt into yellow grass"},
  {true,  "pounding sparking rocks"},
  {false, "with glowing embers"},
  {false, "by dancing to fire circle up in sky"}
};

static int NumofFireWays = (int)(sizeof(Fires)/sizeof(fire_ways_t));

int num_ways_me_get_fire()
{
  return NumofFireWays;
}

bool is_fire_way_gud(int way)
{
  if( (way >= 0) && (way < num_ways_me_get_fire()) )
  {
    return Fires[way].isgood;
  }
  else
  {
    return false;
  }
}

const char *me_get_fire(int way)
{
  if( way < num_ways_me_get_fire() )
  {
    return Fires[way].metellhow;
  }
  else
  {
    return Fires[0].metellhow;
  }
}

const char *me_get_fire_haphaz(int *pway)
{
  static time_t  t = 0;

  int way;

  if( t == 0 )
  {
    srand((unsigned)time(&t));
  }

  way = rand() % num_ways_me_get_fire();

  if( pway != NULL )
  {
    *pway = way;
  }

  return Fires[way].metellhow;
}
