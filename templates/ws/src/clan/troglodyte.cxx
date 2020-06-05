/*! \file
 *
 * \brief Troglodyte class implementation.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Application,clan}
 * \author @PKG_AUTHOR@
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#include <string>
#include <map>
#include <sstream>

#include "troglodyte.h"

using namespace std;

namespace clan
{
  typedef map<FullMoon, const string>  FullMoonNameMap;
  
  static const FullMoonNameMap FullMoonNames =
  {
    {WOLF_MOON,       "Wolf Moon"},
    {SNOW_MOON,       "Snow Moon"},
    {WORM_MOON,       "Worm Moon"},
    {PINK_MOON,       "Pink Moon"},
    {FLOWER_MOON,     "Flower Moon"},
    {STRAWBERRY_MOON, "Strawberry Moon"},
    {BUCK_MOON,       "Buck Moon"},
    {STURGEON_MOON,   "Sturgeon Moon"},
    {CORN_MOON,       "Corn Moon"},
    {HUNTER_MOON,     "Hunter Moon"},
    {BEAVER_MOON,     "Beaver Moon"},
    {COLD_MOON,       "Cold Moon"}
  };
  
  typedef map<Troglodyte::Sex, const string>  SexNameMap;
  
  static const SexNameMap SexNames =
  {
    {Troglodyte::IT,      "it"},
    {Troglodyte::MALE,    "male"},
    {Troglodyte::FEMALE,  "female"},
    {Troglodyte::FLUID,   "fluid"}
  };

  static const string unknown("unknown");
  
  const std::string &full_moon_name(const FullMoon moon)
  {
    FullMoonNameMap::const_iterator it;
    
    it = FullMoonNames.find(moon);
  
    if( it != FullMoonNames.end() )
    {
      return it->second;
    }
    else
    {
      return unknown;
    }
  }

  const std::string &Troglodyte::sex_name(const Sex sex)
  {
    SexNameMap::const_iterator it;
    
    it = SexNames.find(sex);
  
    if( it != SexNames.end() )
    {
      return it->second;
    }
    else
    {
      return unknown;
    }
  }

  const std::string Troglodyte::whatcha_doin()
  {
    std::stringstream ss;

    if( m_activity.empty() )
    {
      ss << m_name << " me doin' nothin'";
    }
    else
    {
      ss << m_activity;
    }

    return ss.str();
  }
} // namespace clan
