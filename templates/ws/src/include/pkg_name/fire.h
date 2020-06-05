/*! \file
 *
 * \brief Fire in the sky, smoke in the eyes.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Library,libpleistocene}
 * \author @PKG_AUTHOR@ 
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#ifndef _@ID_PKG@_FIRE_H
#define _@ID_PKG@_FIRE_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

/*!
 * \brief Methods to make a fire.
 */
typedef enum
{
  FIRE_WAY_MAGIC,       ///< undefined magic way
  FIRE_WAY_LIGHTNING,   ///< lightning
  FIRE_WAY_STICKS,      ///< rubbing two sticks
  FIRE_WAY_HANDS,       ///< rubbing hands
  FIRE_WAY_VOLCANO,     ///< volcano
  FIRE_WAY_BUNNY_BUTT,  ///< lit bunny butt
  FIRE_WAY_FLINT,       ///< strinking flint
  FIRE_WAY_EMBERS,      ///< embers
  FIRE_WAY_DANCING      ///< dancing to sky
} FIRE_WAY;

/*!
 * \brief Get the number of ways our intrepid heroes can make a fire.
 *
 * \return Returns number of methods.
 */
extern int num_ways_me_get_fire();

/*!
 * \brief Test if the way to get fire is good.
 *
 * \param way   Way fire got.
 *
 * \return Returns true (yes way) or false (no way).
 */
extern bool is_fire_way_gud(int way);

/*!
 * \brief Retrieve string name of approach to making fire.
 *
 * \param [in,out] way  Way to get fire.
 *
 * \return Returns null-terminated description string.
 */
extern const char *me_get_fire(int way);

/*!
 * \brief Retrieve string name of fire by haphazard method. Big word.
 *
 * If pway is non-NULL, the chosen fire method is stored at pway.
 *
 * \param [in,out] pway   Way fire got.
 *
 * \return Returns null-terminated description string.
 */
extern const char *me_get_fire_haphaz(int *pway);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // _@ID_PKG@_FIRE_H
