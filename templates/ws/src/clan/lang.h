/*! \file
 *
 * \brief Languages interface.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Application,clan}
 * \author @PKG_AUTHOR@ 
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#ifndef _CLAN_LANG_H
#define _CLAN_LANG_H

#include "utils.h"
#include "grammar.h"

namespace clan
{
  struct Language
  {
    std::string name;       ///< name of language
    StrVec      symbols;    ///< symbols of the language
    StrVec      rules;      ///< rules of the language
  };

  namespace troglodese
  {
    extern Language Troglodese;

    /*!
     * \brief Add stone tool grammar components to the language.
     *
     * \param g   The grammar.
     *
     * \return Returns true on success, false otherwise.
     */
    extern bool add_stone_tools(Grammar &g);

    /*!
     * \brief Add fire grammar components to the language.
     *
     * \param g   The grammar.
     *
     * \return Returns true on success, false otherwise.
     */
    extern bool add_fire(Grammar &g);

  } // namespace troglodese

} // namespace clan

#endif // _CLAN_LANG_H

