/*! \file
 *
 * \brief Grammar class interface.
 *
 * A grammar is composed of a set of [non] terminal symbols, plus a set of
 * rules to generate valid sentences within the language.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Application,clan}
 * \author @PKG_AUTHOR@ 
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#ifndef _CLAN_GRAMMAR_H
#define _CLAN_GRAMMAR_H

#include <memory>
#include <functional>

#include "utils.h"

namespace clan
{
  /*!
   * \brief Simple grammar class.
   */
  class Grammar
  {
  public:
    /*
     * \brief Simple extended subject-verb-object parts of sentence enum.
     *
     *   NP      VP      NP       PVP
     * [-----] [----] [-----] [---------]
     * The man kicked the dog by the foot (bastard, but who? and where?)
     */
    enum ESVO
    {
      SUBJECT,  ///< subject noun phrase
      VERB,     ///< action verb phrase
      OBJECT,   ///< object noun phrase
      PVP,      ///< prepositional or verbal phrase

      NUMOF_ESVOS   ///< number of extra special virgin olives
    };

    /*!
     * \brief Get the name of the sentence part.
     *
     * \param part ESVO enum;
     *
     * \return Reference to ESVO name.
     */ 
    static const std::string &esvo_name(const ESVO part);

    /*!
     * \brief Fired rule callback types.
     */
    typedef std::function<void(ESVO, const std::string &, int, int)> 
                    FiredRuleVoidCallback;
    typedef std::function<std::string(ESVO, const std::string&, int, int)>
                    FiredRuleStringCallback;

    /*!
     * \brief Default constructor.
     */
    Grammar();

    /*!
     * \brief Destructor.
     */
    ~Grammar();

    /*!
     * \brief Load language grammar.
     *
     * Syntax:
     * ```
     * (* list of dictionary symbols *)
     * symbols ::= symbol | symbol symbols
     *
     * (* dictionary symbol *)
     * symbol ::= part ':' phrase
     *          | part ':' phrase '[' phrase-list ']'
     *
     * (* list of rules *)
     * rules ::= rule | rule rules
     *
     * (* rule *)
     * rule ::= part ':' phrase '->' part ':' phrase
     *
     * (* parts of sentence: subject, verb, object, prepostional/verbal *)
     * part ::= 's' | 'v' | 'o' | 'p'
     *
     * phrase-list ::= phrase
     *               | phrase ',' phrase-list
     *
     * (* alphabetic plus space and underscore *)
     * phrase ::= [_A-Z a-z]+
     * ```
     *
     * \param lang    Name of language.
     * \param symbols Vector of string coded symbols.
     * \param rules   Vector of string coded production rules.
     *
     * \return Returns true on success, false otherwise.
     */
    bool load(const std::string lang, StrVec &symbols, StrVec &rules);

    /*!
     * \brief Parse vector of string coded symbols and load into grammar.
     *
     * \param symbols Vector of string coded symbols.
     *
     * \return Returns true on success, false otherwise.
     */
    bool parse_symbols(const StrVec &symbols);

    /*!
     * \brief Parse string coded symbol and load into grammar.
     *
     * \param symbol  String coded symbol.
     *
     * \return Returns true on success, false otherwise.
     */
    bool parse_symbol(const std::string &symbol);

    /*!
     * \brief Parse vector of string coded rules and load into grammar.
     *
     * \param rules Vector of string coded rules.
     *
     * \return Returns true on success, false otherwise.
     */
    bool parse_rules(const StrVec &rules);

    /*!
     * \brief Parse string coded rule and load into grammar.
     *
     * \param rule  String coded rule.
     *
     * \return Returns true on success, false otherwise.
     */
    bool parse_rule(const std::string &rule);
 
    /*!
     * \brief Set language name.
     *
     * \param lang    Name of language.
     */
    void language(const std::string lang);

    /*!
     * \brief Get language name.
     *
     * \returns Returns reference to string.
     */
    const std::string &language() const;

    /*!
     * \brief Add terminal phrase to grammar.
     *
     * \param part    Subject, verb, object, pvp sentence part.
     * \param phrase  Phrase to add and it's own group identifier.
     *
     * \return Returns true on success, false otherwise.
     */
    bool add_symbol(ESVO part, const std::string phrase);

    /*!
     * \brief Add non-terminal group of terminal phrases to grammar.
     *
     * \param part    Subject, verb, object, pvp sentence part.
     * \param key     Group identifier non-terminal symbol.
     * \param phrases Vector of phrases to add.
     *
     * \return Returns true on success, false otherwise.
     */
    bool add_symbol(ESVO part, const std::string key, const StrVec &phrases);

    /*!
     * \brief Add a grammar production rule to grammer.
     *
     * The symbols must already exist in the symbol dictionary.
     *
     * The rule may have multiple productions.
     *
     * ```
     * rule -> sym_1
     * rule -> sym_2
     *  ...
     *  ```
     *
     * \param lhs_part  Left hand side trigger part-of-sentence.
     * \param lhs       Left hand side trigger.
     * \param rhs_part  Right hand side production part-of-sentence.
     * \param rhs       Right hand side production dictionary key.
     *
     * \return Returns true on success, false otherwise.
     */
    bool add_rule(ESVO lhs_part, const std::string lhs,
                  ESVO rhs_part, const std::string rhs);

    /*!
     * \brief Generate random sentence within the grammar.
     *
     * \returns string.
     */
    std::string random_sentence();

    /*!
     * \brief Print out grammar symbols.
     */
    void print_symbols() const;

    /*!
     * \brief Print out grammar rules.
     */
    void print_rules() const;

    /*!
     * \brief Print out a generated grammar tree.
     *
     * \param max_depth   Maximum depth of rule production.
     */
    void print_tree(int max_depth=NUMOF_ESVOS) const;

    /*!
     * \brief Test features.
     */
    int test_rand(int mod);

  protected:

  private:
    class Impl;                     ///< forward declaration
    std::unique_ptr<Impl> pimpl;    ///< private implementation
  };

} // namespace clan

#endif // _CLAN_GRAMMAR_H
