/*! \file
 *
 * \brief Grammar class implementation.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Application,clan}
 * \author @PKG_AUTHOR@
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#include <memory>
#include <string>
#include <vector>
#include <map>
#include <random>
#include <functional>
#include <regex>
#include <iostream>
#include <iomanip>

#include "utils.h"
#include "grammar.h"

namespace clan
{
  using namespace std::placeholders;
  
  /*! Map of vector of strings type. */
  typedef std::map<std::string, std::vector<std::string> > MapOfStrVecs;

  /*!
   * \brief Grammer rule pattern.
   */
  struct RulePat
  {
    Grammar::ESVO m_part;   ///< part of sentence grammar
    std::string   m_sym;    ///< [non] terminal grammar symbol

    RulePat(Grammar::ESVO part, const std::string sym)
      : m_part(part), m_sym(sym)
    {
    }

    ~RulePat() = default;
  };

  /*! vector of rule patterns */
  typedef std::vector<RulePat>  RulePatVec;

  /*!
   * \brief Parse regular expressions.
   * \{
   */
  static const std::string ReGrpPart("([svop])");
  static const std::string ReGrpPhrase("([_A-Za-z0-9 ]+)");
  static const std::string ReGrpBracketed("(\\[.*\\])?");
  static const std::regex ReSym(ReGrpPart +":" + ReGrpPhrase + ReGrpBracketed);
  static const std::regex RePhraseList(ReGrpPhrase + ",?(.*)");
  static const std::regex ReRule(ReGrpPart + ":" + ReGrpPhrase
                                 + "[ ]*->[ ]*"
                                 + ReGrpPart + ":" + ReGrpPhrase);

  /*! \} */

  /*!
   * \brief Grammar internal implementation class.
   */
  class Grammar::Impl
  {
  public:
    /*!
     * \brief Default constructor.
     */
    Impl() : m_dist(0, 10'000)
    {
      m_rng.seed(rng_seed());
    }

    /*!
     * \brief Random integer from uniform distribution [0, mod).
     */
    int rand(int mod)
    {
      return m_dist(m_rng) % mod;
    }

    /*!
     * \brief Random string from vector of strings.
     */
    const std::string &rand(const StrVec &vec)
    {
      return vec[rand((int)vec.size())];
    }

    /*!
     * \brief Random map key weighted by size of key vectors.
     */
    const std::string &rand(const MapOfStrVecs &m)
    {
      size_t  n;
      MapOfStrVecs::const_iterator it;

      // count total number of entries
      for(n=0, it=m.begin(); it!=m.end(); ++it)
      {
        n += it->second.size();
      }

      int r = rand(n);

      // find random entry
      for(n=0, it=m.begin(); it!=m.end(); ++it)
      {
        n += it->second.size();
        if( r < n )
        {
          return it->first;
        }
      }
      return m.begin()->first;
    }

    /*!
     * \copydoc clan::Grammor::load
     */
    bool load(const std::string lang, StrVec &symbols, StrVec &rules)
    {
      language(lang);

      if( !parse_symbols(symbols) )
      {
        return false;
      }

      else if( !parse_rules(rules) )
      {
        return false;
      }

      else
      {
        return true;
      }
    }

    /*!
     * \copydoc clan::Grammor::parse_symbols
     */
    bool parse_symbols(const StrVec &symbols)
    {
      bool good = true;

      for(size_t n=0; n<symbols.size() && good; ++n)
      {
        good = parse_symbol(symbols[n]);
      }

      return good;
    }

    /*!
     * \copydoc clan::Grammor::parse_symbol
     */
    bool parse_symbol(const std::string &symbol)
    {
      std::cmatch cm;

      std::regex_match(symbol.c_str(), cm, ReSym);

      if( cm.size() != 4 )
      {
        std::cerr << "error: coded symbol '" << symbol << "' is invalid"
          << std::endl;
        return false;
      }

      ESVO part = char_to_part(trim(cm[1]));
      std::string sym(trim(cm[2]));

      if( cm[3] == "" )
      {
        return add_symbol(part, sym);
      }
      else
      {
        StrVec      vec;
        std::string list(cm[3]);
        list = list.substr(1,list.size()-2);  // remove bracket cap

        while(true)
        {
          std::regex_match(list.c_str(), cm, RePhraseList);
          if( cm.size() != 3 )
          {
            break;
          }
          else
          {
            vec.push_back(trim(cm[1]));
            list = cm[2];
          }
        }
        return add_symbol(part, sym, vec);
      }
    }

    /*!
     * \copydoc clan::Grammor::parse_rules
     */
    bool parse_rules(const StrVec &rules)
    {
      bool good = true;

      for(size_t n=0; n<rules.size() && good; ++n)
      {
        good = parse_rule(rules[n]);
      }

      return good;
    }

    /*!
     * \copydoc clan::Grammor::parse_rule
     */
    bool parse_rule(const std::string &rule)
    {
      std::cmatch cm;

      std::regex_match(rule.c_str(), cm, ReRule);

      if( cm.size() != 5 )
      {
        std::cerr << "error: coded rule '" << rule << "' is invalid"
          << std::endl;
        return false;
      }

      ESVO lhs_part = char_to_part(trim(cm[1]));
      std::string lhs(trim(cm[2]));

      ESVO rhs_part = char_to_part(trim(cm[3]));
      std::string rhs(trim(cm[4]));

      return add_rule(lhs_part, lhs, rhs_part, rhs);
    }

    void language(const std::string lang)
    {
      m_lang = lang;
    }

    const std::string &language() const
    {
      return m_lang;
    }

    /*!
     * \copydoc clan::Grammar::add_symbol
     */
    bool add_symbol(ESVO part, const std::string phrase)
    {
      StrVec vec = {phrase};

      m_dict[part][phrase] = vec;

      return true;
    }

    /*!
     * \copydoc clan::Grammar::add_symbol
     */
    bool add_symbol(ESVO part, const std::string key, const StrVec &phrases)
    {
      // new
      if( m_dict[part].find(key) == m_dict[part].end() )
      {
        m_dict[part][key] = phrases;
      }
      // join the team
      else
      {
        join(m_dict[part][key], phrases);
      }

      // add terminals
      for(StrVec::const_iterator it=phrases.begin(); it!=phrases.end(); ++it)
      {
        if( !add_symbol(part, *it) )
        {
          return false;
        }
      }
      return true;
    }

    /*!
     * \copydoc clan::Grammar::add_rule
     */
    bool add_rule(ESVO lhs_part, const std::string lhs,
                  ESVO rhs_part, const std::string rhs)
    {
      MapOfStrVecs::iterator pos;

      // checks
      if( m_dict[lhs_part].find(lhs) == m_dict[lhs_part].end() )
      {
        std::cerr << "error: " << esvo_name(lhs_part) << " '" << lhs
          << "' not found" << std::endl;
        return false;
      }
      else if( m_dict[rhs_part].find(rhs) == m_dict[rhs_part].end() )
      {
        std::cerr << "error: " << esvo_name(rhs_part) << " '" << rhs
          << "' not found" << std::endl;
        return false;
      }

      set_rule(lhs, rhs_part, rhs);

      return true;
    }

    /*!
     * \copydoc clan::Grammar::random_sentence
     */
    std::string random_sentence()
    {
      std::string key = rand(m_dict[SUBJECT]);
      return random_sentence_r(SUBJECT, key, 0, NUMOF_ESVOS);
    }

    /*!
     * \copydoc clan::Grammar::print_symbols
     */
    void print_symbols(ESVO part)
    {
      MapOfStrVecs::iterator  it;   // iterator over a map of string vectors
      
      for(it=m_dict[part].begin(); it!=m_dict[part].end(); ++it)
      {
        std::cout << std::setw(24) << std::left << it->first;

        print_vec(it->second, 0, 24, 4);
      }
    }

    /*!
     * \copydoc clan::Grammar::print_rules
     */
    void print_rules()
    {
      std::string indent("  ");

      for(Rules::iterator rit=m_rules.begin(); rit!=m_rules.end(); ++rit)
      {
        std::cout << rit->first << " ->" << std::endl;
        for(RulePatVec::iterator pit=rit->second.begin();
            pit!=rit->second.end();
            ++pit)
        {
          std::cout << indent << esvo_name(pit->m_part) << ":'"
            << pit->m_sym << "'" << std::endl;
        }
      }
    }

    /*!
     * \copydoc clan::Grammar::print_tree
     */
    void print_tree(int max_depth)
    {
      for(MapOfStrVecs::iterator it=m_dict[SUBJECT].begin();
          it!=m_dict[SUBJECT].end();
          ++it)
      {
        print_tree_r(SUBJECT, it->first, 0, max_depth);
      }
    }

    /*!
     * \brief Fire all productions from a rule.
     *
     * A callback is made for each firing.
     *
     * \param rule      Rule.
     * \param depth     Current recursion depth.
     * \param max_depth Maximum allowed recursion depth.
     * \param cb        Callback void function.
     */
    void fire_all(const std::string &rule,
                  int depth,
                  int max_depth,
                  FiredRuleVoidCallback cb)
    {
      if( depth >= max_depth )
      {
        return;
      }
      else if( m_rules.find(rule) == m_rules.end() )
      {
        return;
      }

      for(RulePatVec::iterator it=m_rules[rule].begin();
          it!=m_rules[rule].end();
          ++it)
      {
        ESVO part = it->m_part;
        std::string &sym = it->m_sym;
        cb(part, sym, depth, max_depth);
      }
    }

    /*!
     * \brief Fire all productions from a rule.
     *
     * A callback is made for each firing.
     *
     * \param rule      Rule.
     * \param depth     Current recursion depth.
     * \param max_depth Maximum allowed recursion depth.
     * \param cb        Callback function returning string.
     *
     * \return Returns generated string.
     */
    std::string fire_all_string(const std::string &rule,
                                int depth,
                                int max_depth,
                                FiredRuleStringCallback cb)
    {
      if( depth >= max_depth )
      {
        return "";
      }
      else if( m_rules.find(rule) == m_rules.end() )
      {
        return "";
      }

      for(RulePatVec::iterator it=m_rules[rule].begin();
          it!=m_rules[rule].end();
          ++it)
      {
        ESVO part = it->m_part;
        std::string &sym = it->m_sym;
        return cb(part, sym, depth, max_depth);
      }
    }

    /*!
     * \brief Fire rule randomly for produce random production from rule.
     *
     * ```
     * rule -> rand_prod
     * ```
     *
     * \param rule      Rule.
     * \param depth     Current recursion depth.
     * \param max_depth Maximum allowed recursion depth.
     * \param cb        Callback void function.
     */
    void fire_random(const std::string &rule,
                     int depth,
                     int max_depth,
                     FiredRuleVoidCallback cb)
    {
      if( depth >= max_depth )
      {
        return;
      }
      else if( m_rules.find(rule) == m_rules.end() )
      {
        return;
      }

      int r = rand((int)m_rules[rule].size());

      cb(m_rules[rule][r].m_part, m_rules[rule][r].m_sym, depth, max_depth);
    }

    /*!
     * \brief Fire rule randomly for produce random production from rule.
     *
     * ```
     * rule -> rand_prod
     * ```
     *
     * \param rule      Rule.
     * \param depth     Current recursion depth.
     * \param max_depth Maximum allowed recursion depth.
     * \param cb        Callback function returning string.
     *
     * \return Returns generated string.
     */
    std::string fire_random_string(const std::string &rule,
                                   int depth,
                                   int max_depth,
                                   FiredRuleStringCallback cb)
    {
      if( depth >= max_depth )
      {
        return "";
      }
      else if( m_rules.find(rule) == m_rules.end() )
      {
        return "";
      }

      int r = rand((int)m_rules[rule].size());

      return cb(m_rules[rule][r].m_part,
                               m_rules[rule][r].m_sym,
                               depth,
                               max_depth);
    }

  protected:
    /*!
     * \brief Recursively build random sentence (fragment).
     *
     * \param part      Part of sentence.
     * \param key       Dictionary key.
     * \param depth     Current recursion depth.
     * \param max_depth Maximum allowed recursion depth.
     *
     * \return Returns string.
     */
    std::string random_sentence_r(ESVO part,
                                  const std::string &key,
                                  int depth,
                                  int max_depth)
    {
      if( depth >= max_depth )
      {
        return "";
      }

      auto cb = std::bind(&Impl::random_sentence_r, this, _1, _2, _3, _4);
      
      int n = (int)m_dict[part][key].size();        // number of terminals

      // sentence fragments
      std::string phrase(m_dict[part][key][rand(n)]); // front phrase
      std::string back_phrases;                       // back phrases

      StrVec keys;

      find_keys_with_phrase(phrase, m_dict[part], keys);

      while( keys.size() > 0 )
      {
        int r = rand((int)keys.size());
        back_phrases = fire_random_string(keys[r], depth+1, max_depth, cb);
        if( !back_phrases.empty() )
        {
          break;
        }
        keys.erase(keys.begin()+r);
      }

      if( back_phrases.empty() )
      {
        return phrase;
      }
      else
      {
        return phrase + " " + back_phrases;
      }
    }

    /*!
     * \brief Recursively print generated grammer tree (fragment).
     *
     * \param part      Part of sentence.
     * \param sym       Dictionary symbol.
     * \param depth     Current recursion depth.
     * \param max_depth Maximum allowed recursion depth.
     */
    void print_tree_r(ESVO part,
                      const std::string &sym,
                      int depth,
                      int max_depth)
    {
      if( depth >= max_depth )
      {
        return;
      }

      auto cb = std::bind(&Impl::print_tree_r, this, _1, _2, _3, _4);
      
      bool nonterm = sym != m_dict[part][sym][0];

      for(StrVec::iterator it=m_dict[part][sym].begin();
          it!=m_dict[part][sym].end();
          ++it)
      {
        std::cout << std::setw(depth*2) << "" << *it << "/" << std::endl;
        fire_all(*it, depth+1, max_depth, cb);
        if( nonterm )
        {
          fire_all(sym, depth+1, max_depth, cb);
        }
      }
    }

    /*!
     * \brief Map character to part of sentence enum.
     *
     * \param c   Character.
     *
     * \return Returns ESVO enum.
     */
    ESVO char_to_part(const std::string &s)
    {
      switch( s[0] )
      {
        case 's':
          return SUBJECT;
        case 'v':
          return VERB;
        case 'o':
          return OBJECT;
        case 'p':
        default:
          return PVP;
      }
    }

    /*!
     * \brief Blindly add rule to rules.
     *
     * \param lhs       Left hand side trigger.
     * \param rhs_part  Right hand side production part-of-sentence.
     * \param rhs       Right hand side production dictionary key.
     */
    void set_rule(const std::string lhs, ESVO rhs_part, const std::string rhs)
    {
      // new rule
      if( m_rules.find(lhs) == m_rules.end() )
      {
        m_rules[lhs] = RulePatVec({RulePat(rhs_part, rhs)});
      }

      // append to existing rule productions
      else
      {
        m_rules[lhs].push_back(RulePat(rhs_part, rhs));
      }
    }

    size_t find_keys_with_phrase(const std::string phrase,
                                 const MapOfStrVecs &m,
                                 StrVec &keys)
    {
      MapOfStrVecs::const_iterator mit;
      StrVec::const_iterator vit;

      // count total number of entries
      for(mit=m.begin(); mit!=m.end(); ++mit)
      {
        for(vit=mit->second.begin(); vit!=mit->second.end(); ++vit)
        {
          if( phrase == *vit )
          {
            keys.push_back(mit->first);
            break;
          }
        }
      }
      return keys.size();
    }

  private:
    typedef std::map<ESVO, MapOfStrVecs>  Dictionary;
    typedef std::map<std::string, RulePatVec>   Rules;

    std::default_random_engine m_rng;           ///< random number generator
    std::uniform_int_distribution<int> m_dist;  ///< uniform distribution

    std::string m_lang;   ///< language name
    Dictionary  m_dict;   ///< grammar symbols
    Rules       m_rules;  ///< grammar generative rules
  };

  // --------------------------------------------------------------------------
  // Grammar public implementation

  typedef std::map<Grammar::ESVO, const std::string> EsvoNameMap;
  
  static std::string what("???");

  static const EsvoNameMap EsvoNames =
  {
    {Grammar::SUBJECT,  "SUBJECT"},
    {Grammar::VERB,     "VERB"},
    {Grammar::OBJECT,   "OBJECT"},
    {Grammar::PVP,      "PVP"}
  };

  const std::string &Grammar::esvo_name(const ESVO part)
  {
    EsvoNameMap::const_iterator it;
    
    it = EsvoNames.find(part);
  
    if( it != EsvoNames.end() )
    {
      return it->second;
    }
    else
    {
      return what;
    }
  }

  Grammar::Grammar() : pimpl(std::make_unique<Impl>())
  {
  }

  Grammar::~Grammar() = default;

  bool Grammar::load(const std::string lang, StrVec &symbols, StrVec &rules)
  {
    return pimpl->load(lang, symbols, rules);
  }

  bool Grammar::parse_symbols(const StrVec &symbols)
  {
    return pimpl->parse_symbols(symbols);
  }

  bool Grammar::parse_symbol(const std::string &symbol)
  {
    return pimpl->parse_symbol(symbol);
  }

  bool Grammar::parse_rules(const StrVec &rules)
  {
    return pimpl->parse_rules(rules);
  }

  bool Grammar::parse_rule(const std::string &rule)
  {
    return pimpl->parse_rule(rule);
  }

  void Grammar::language(const std::string lang)
  {
    pimpl->language(lang);
  }

  const std::string &Grammar::language() const
  {
    return pimpl->language();
  }

  bool Grammar::add_symbol(ESVO part, const std::string phrase)
  {
    return pimpl->add_symbol(part, phrase);
  }

  bool Grammar::add_symbol(ESVO part,
                           const std::string key,
                           const StrVec &phrases)
  {
    return pimpl->add_symbol(part, key, phrases);
  }

  bool Grammar::add_rule(ESVO lhs_part, const std::string lhs,
                         ESVO rhs_part, const std::string rhs)
  {
    return pimpl->add_rule(lhs_part, lhs, rhs_part, rhs);
  }

  std::string Grammar::random_sentence()
  {
    return pimpl->random_sentence();
  }

  void Grammar::print_symbols() const
  {
    for(int part = SUBJECT; part < NUMOF_ESVOS; ++part)
    {
      std::cout << "  " << esvo_name((ESVO)part) << std::endl;
      pimpl->print_symbols((ESVO)part);
      std::cout << std::endl;
    }
  }

  void Grammar::print_rules() const
  {
    pimpl->print_rules();
  }

  void Grammar::print_tree(int max_depth) const
  {
    pimpl->print_tree(max_depth);
  }

  int Grammar::test_rand(int mod)
  {
    return pimpl->rand(mod);
  }

} // namespace clan
