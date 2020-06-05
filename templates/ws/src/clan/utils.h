/*! \file
 *
 * \brief Utilities interface.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Application,clan}
 * \author @PKG_AUTHOR@ 
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#ifndef _CLAN_UTILS_H
#define _CLAN_UTILS_H

#include <string>
#include <vector>

namespace clan
{
  /*!
   * Common types.
   */
  typedef std::vector<std::string> StrVec;
  typedef std::vector<int> IntVec;

  /*!
   * \brief Trim leading left whitespace from string.
   *
   * \param s   String to trim.
   *
   * \return Returns left trimmed string;
   */
  extern std::string ltrim(const std::string& s);

  /*!
   * \brief Trim trailing right whitespace from string.
   *
   * \param s   String to trim.
   *
   * \return Returns right trimmed string;
   */
  extern std::string rtrim(const std::string& s);

  /*!
   * \brief Trim left and right whitespace from string.
   *
   * \param s   String to trim.
   *
   * \return Returns trimmed string;
   */
  extern std::string trim(const std::string& s);

  /*!
   * \brief Joint to vectors.
   *
   * \param a Target reference to vector to joined.
   * \param b Joinee vector.
   *
   * \return Returns reference to a.
   * \{
   */
  inline StrVec &join(StrVec &a, const StrVec &b)
  {
    a.insert(a.end(), b.begin(), b.end());
    return a;
  }

  inline IntVec &join(IntVec &a, const IntVec &b)
  {
    a.insert(a.end(), b.begin(), b.end());
    return a;
  }
  /*! \} */

  /*!
   * \brief Print vector of strings to stdout.
   *
   * \param vec       Vector to print contents.
   * \param indent0   First line indentation.
   * \param indent1   Subsequent lines indentation.
   * \param elems     Number of elements/line.   
   */
  extern void print_vec(const StrVec &vec,
                        int indent0 = 0,
                        int indent1 = 0,
                        int elems = 8);

  /*!
   * \brief Print vector of integers to stdout.
   *
   * \param vec       Vector to print contents.
   * \param indent0   First line indentation.
   * \param indent1   Subsequent lines indentation.
   * \param elems     Number of elements/line.   
   */
  extern void print_vec(const IntVec &vec,
                        int indent0 = 0,
                        int indent1 = 0,
                        int elems = 16);

  /*!
   * \brief Create random number generator seed from system clock.
   *
   * \return Seed.
   */
  extern unsigned rng_seed();

} // namespace clan

#endif // _CLAN_UTILS_H

