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

#include "@PKG_NAME@/stone_tools.h"
#include "@PKG_NAME@/fire.h"

#include "utils.h"
#include "grammar.h"
#include "lang.h"

namespace clan
{
  namespace troglodese
  {

    /*!
     * \brief The Troglodese language.
     *
     * This is the static component of the language.
     *
     * \sa clan::Grammar::load
     */
    Language Troglodese = 
    {
      // name
      "Troglodese",
  
      // dictionary symbols
      { "s:Terry the Terror Bird",
        "s:A rock",
        "s:CLAN[Trog, Mini Trog, Baby Trog]",
        "s:ADULTS[Trog]",
        "s:URCHINS[Mini Trog]",
        "s:CAVIES[Baby Trog]",
  
        "v:DAILY_TASKS[gathers, grinds, makes, builds, cooks, eats, sleeps]",
        "v:DANGEROUS[hunts, scavenges]",
        "v:LOCOMOTION[walks, ambles, trots, runs]",
        "v:CREEP[crawls, creeps, waddles]",
        "v:steals",
        "v:ROCKS[rolls, drops, is thrown]",
        "v:is",
        "v:is feeling",
        "v:is a",
        "v:likes",
        "v:not like",
  
        "o:PREY[glyptodon, capybara, titi monkey, hippidion, "
               "lestodon ground sloth, toxodon]",
        "o:GATHERED[grubs, tool stones, wood, eggs, termites, teosinte, "
                   "quinoa, amaranth]", 
        "o:CARRION[rotting gomphothere thigh, arctotherium rump, "
                 "questionable carrion]",
        "o:STONE_TOOLS_MADE[broken stone]",
        "o:FOOD[glyptodon, capybara, titi monkey, hippidion, "
               "lestodon ground sloth, toxodon, grubs, eggs, termites, "
               "teosinte, quinoa, amaranth, rotting gomphothere thigh, "
               "arctotherium rump, questionable carrion]",
        "o:COOKING_FOOD[glyptodon, capybara, titi monkey, hippidion, "
               "lestodon ground sloth, toxodon, eggs, "
               "rotting gomphothere thigh, arctotherium rump, "
               "questionable carrion]",
        "o:GRINDING_FOOD[teosinte, quinoa, amaranth]",
        "o:EMOTION[happy, sad, mad, an existential crisis]",
        "o:a fire",
        "o:a troglodyte",
        "o:LOOT[table scraps, a rock, a troglodyte]",
        "o:DEST[to the cave, along the river, in the forest, backwards]", 
        "o:ART[cave painting, hand shadow puppet, shell ornament, shiny rock]",
  
        "p:by the tail",
        "p:at the creek",
        "p:using a stick",
        "p:WHEN[at dawn, when sun up high, when me hungry]",
        "p:with a stalk of grass",
        "p:WITH_WEAPON[with hands and teeth, with a rock, with a hand axe, "
                      "with old spear, by abusive name calling]",
        "p:FIRE_METHOD[with fuel oxygen heat as like triangle]",
      },
  
      // production rules
      { "s:ADULTS -> v:DAILY_TASKS",
        "s:ADULTS -> v:LOCOMOTION",
        "s:ADULTS -> v:DANGEROUS",
        "s:URCHINS -> v:DAILY_TASKS",
        "s:URCHINS -> v:LOCOMOTION",
        "s:CAVIES -> v:CREEP",
        "s:CLAN -> v:is feeling",
        "s:Terry the Terror Bird -> v:steals",
        "s:A rock -> v:ROCKS",
        "s:CLAN -> v:likes",
        "s:CLAN -> v:not like",
  
        "v:is -> o:a troglodyte",
        "v:is feeling -> o:EMOTION",
        "v:hunts -> o:PREY",
        "v:scavenges -> o:CARRION",
        "v:gathers -> o:GATHERED",
        "v:gathers -> p:using a stick",
        "v:makes -> o:STONE_TOOLS_MADE",
        "v:builds -> o:a fire",
        "v:eats -> o:FOOD",
        "v:grinds -> o:GRINDING_FOOD",
        "v:cooks -> o:COOKING_FOOD",
        "v:steals -> o:LOOT",
        "v:LOCOMOTION -> o:DEST",
        "v:likes -> o:ART",
        "v:not like -> o:ART",
  
        "o:PREY -> p:WHEN",
        "o:PREY -> p:WITH_WEAPON",
        "o:GATHERED -> p:WHEN",
        "o:grubs -> p:using a stick",
        "o:termites -> p:with a stalk of grass",
        "o:a fire -> p:FIRE_METHOD",
      }
    };

    bool add_stone_tools(Grammar &g)
    {
      STONE_TOOL first = STONE_TOOL((int)STONE_TOOL_UNKNOWN + 1);
      STONE_TOOL numof = NUMOF_STONE_TOOLS;
      STONE_TOOL made[] =
      {
        STONE_TOOL_HAMMERSTONE, STONE_TOOL_FLAKE, STONE_TOOL_HAND_AXE,
        STONE_TOOL_BLADE, STONE_TOOL_POINT, STONE_TOOL_AWL,
        STONE_TOOL_SCRAPPER, STONE_TOOL_BURIN,  
        STONE_TOOL_UNKNOWN
      };
      STONE_TOOL grind[] =
      {
        STONE_TOOL_QUERN, STONE_TOOL_MULLER, STONE_TOOL_UNKNOWN
      };
      STONE_TOOL discard[] = {STONE_TOOL_CORE, STONE_TOOL_UNKNOWN};

      //StrVec  names;
      StrVec  vec;
      int     tool;

      //for(tool=first; tool<numof; ++tool)
      //{
      //  names.push_back(name_of_stone_tool((STONE_TOOL)tool));
      //}

      //if( !g.add_symbol(Grammar::ESVO::SUBJECT, "STONE_TOOLS", names) )
      //{
      //  return false;
      //} 

      for(tool=0; made[tool]!=STONE_TOOL_UNKNOWN; ++tool)
      {
        vec.push_back(name_of_stone_tool(made[tool]));
      }

      if( !g.add_symbol(Grammar::ESVO::OBJECT, "STONE_TOOLS_MADE", vec) )
      {
        return false;
      } 

      return true;
    }

    bool add_fire(Grammar &g)
    {
      int     way;
      StrVec  methods;

      for(way=0; way<num_ways_me_get_fire(); ++way)
      {
        methods.push_back(me_get_fire(way));
      }

      if( !g.add_symbol(Grammar::ESVO::PVP, "FIRE_METHOD", methods) )
      {
        return false;
      } 

      return true;
    }

  } // namespace troglodese

} // namespace clan
