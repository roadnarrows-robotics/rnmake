
/*! \file
 *
 * \brief Languages spoken back in the day.
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
#include <vector>
#include <chrono>
#include <iostream>
#include <iomanip>

#include "utils.h"

namespace clan
{
  static const std::string WHITESPACE = " \n\r\t\f\v";

  std::string ltrim(const std::string& s)
  {
	  size_t start = s.find_first_not_of(WHITESPACE);
	  return (start == std::string::npos) ? "" : s.substr(start);
  }

  std::string rtrim(const std::string& s)
  {
	  size_t end = s.find_last_not_of(WHITESPACE);
	  return (end == std::string::npos) ? "" : s.substr(0, end + 1);
  }

  std::string trim(const std::string& s)
  {
	  return rtrim(ltrim(s));
  }

  void print_vec(const StrVec &vec, int indent0, int indent1, int elems)
  {
    int indent = indent0;
    int rem;
    int eol = elems - 1;

    for(size_t i=0; i<vec.size(); ++i)
    {
      rem = i % elems;
      if( rem == 0 )
      {
        std::cout << std::setw(indent) << "" << std::setw(0);
      }
      std::cout << "'" << vec[i] << "' ";
      if( rem == eol )
      {
        std::cout << std::endl;
        indent = indent1;
      }
    }
    if( rem != eol )
    {
      std::cout << std::endl;
    }
  }

  void print_vec(const IntVec &vec, int indent0, int indent1, int elems)
  {
    int indent = indent0;
    int rem;
    int eol = elems - 1;

    for(size_t i=0; i<vec.size(); ++i)
    {
      rem = i % elems;
      if( rem == 0 )
      {
        std::cout << std::setw(indent) << "" << std::setw(0);
      }
      std::cout << vec[i] << " ";
      if( rem == eol )
      {
        std::cout << std::endl;
        indent = indent1;
      }
    }
    if( rem != eol )
    {
      std::cout << std::endl;
    }
  }

  unsigned rng_seed()
  {
    std::chrono::system_clock::time_point tp = std::chrono::system_clock::now();
    std::chrono::system_clock::duration tse = tp.time_since_epoch();
    return (unsigned)tse.count();
  }

} // namespace clan
