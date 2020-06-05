/*! \file
 *
 * \brief A library of stone tools.
 *
 * \pkgfile{stone_tools.c}
 * \pkgcomponent{Library,libpleistocene}
 * \author @PKG_AUTHOR@
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#include <stddef.h>

#include "@PKG_NAME@/stone_tools.h"

/*!
 * \brief integer key - string value associated structure.
 */
typedef struct
{
  int         key;  ///< key integer value
  const char *val;  ///< associated character string
} assoc_str_t;

/*!
 * \brief Integer key - integer value associated structure.
 */
typedef struct
{
  int key;    ///< key integer value
  int val;    ///< assicated integer value
} assoc_int_t;

/*!
 * \brief Associated array of stone tool to string name.
 */
static assoc_str_t StoneToolName[] =
{
  {STONE_TOOL_UNKNOWN,      "unknown"},
  {STONE_TOOL_HAMMERSTONE,  "hammerstone"},
  {STONE_TOOL_CORE,         "stone core"},
  {STONE_TOOL_FLAKE,        "flake"},
  {STONE_TOOL_HAND_AXE,     "hand axe"},
  {STONE_TOOL_BLADE,        "stone blade"},
  {STONE_TOOL_POINT,        "stone point"},
  {STONE_TOOL_AWL,          "stone awl"},
  {STONE_TOOL_SCRAPPER,     "scrapper"},
  {STONE_TOOL_BURIN,        "burin"},
  {STONE_TOOL_QUERN,        "quern"},
  {STONE_TOOL_MULLER,       "muller"}
};

/*!
 * \brief Associated array of stone tool to string description.
 */
static assoc_str_t StoneToolDesc[] =
{
  {STONE_TOOL_UNKNOWN,      "unknown"},
  {STONE_TOOL_HAMMERSTONE,  "hard cobble to strike a tool stone"},
  {STONE_TOOL_CORE,         "tool stone remnant"},
  {STONE_TOOL_FLAKE,        "multitool and/or discard"},
  {STONE_TOOL_HAND_AXE,     "handheld axe, no shaft"},
  {STONE_TOOL_BLADE,        "long narrow flakes used in composite tools"},
  {STONE_TOOL_POINT,        "points hafted to spears and arrows"},
  {STONE_TOOL_AWL,          "punch tool to perforate hides"},
  {STONE_TOOL_SCRAPPER,     "scrapper to prepare hides and wood"},
  {STONE_TOOL_BURIN,        "handheld lithic engraving flake "},
  {STONE_TOOL_QUERN,        "lower, stationary stone for hand-grinding"},
  {STONE_TOOL_MULLER,       "upper, mobile handstone for hand-grinding"}
};

/*!
 * \brief Associated array of lithic mode to string name.
 */
static assoc_str_t LithicModeName[] =
{
  {LITHIC_MODE_UNKNOWN, "unknown"},
  {LITHIC_MODE_PRE_I,   "Pre-Mode I"},
  {LITHIC_MODE_I,       "Mode I"},
  {LITHIC_MODE_II,      "Mode II"},
  {LITHIC_MODE_III,     "Mode III"},
  {LITHIC_MODE_IV,      "Mode IV"},
  {LITHIC_MODE_V,       "Mode V"}
};

/*!
 * \brief Associated array of lithic mode to string description.
 */
static assoc_str_t LithicModeDesc[] =
{
  {LITHIC_MODE_UNKNOWN, "unknown"},
  {LITHIC_MODE_PRE_I,   "predates genus Homo"},
  {LITHIC_MODE_I,       "Oldowan industry of simple core construction"},
  {LITHIC_MODE_II,      "Acheulean industry defined by the biface"},
  {LITHIC_MODE_III,     "Mousterian industry of the Levallois technique"},
  {LITHIC_MODE_IV,      "Aurignacian industry defined by blades"},
  {LITHIC_MODE_V,       "Microlithic industry refined composite tools"}
};

/*!
 * \brief Associated array of lithic mode to kya of first appearance.
 */
static assoc_int_t LithicModeEarliest[] =
{
  {LITHIC_MODE_UNKNOWN, 0},
  {LITHIC_MODE_PRE_I,   3300},
  {LITHIC_MODE_I,       2600},
  {LITHIC_MODE_II,      1700},
  {LITHIC_MODE_III,     160},
  {LITHIC_MODE_IV,      50},
  {LITHIC_MODE_V,       35}
};

/*!
 * \brief Search for value with key in associated array.
 *
 * \param key     Integer key.
 * \param assoc   Association array.
 * \param n       Size of array (number of elements).
 *
 * \return If key is found, the associated null-terminated string value is
 * return. Otherwise, the first element's value is returned.
 */
static const char *search_str_assoc(int key, assoc_str_t assoc[], size_t n)
{
  for(size_t i = 0; i < n; ++i)
  {
    if(assoc[i].key == key)
    {
      return assoc[i].val;
    }
  }

  return assoc[0].val;
}

/*!
 * \brief Search for value with key in associated array.
 *
 * \param key     Integer key.
 * \param assoc   Associated array.
 * \param n       Size of array (number of elements).
 *
 * \return If key is found, the associated integer value is return.
 * Otherwise, the first element's value is returned.
 */
static int search_int_assoc(int key, assoc_int_t assoc[], size_t n)
{
  for(size_t i = 0; i < n; ++i)
  {
    if(assoc[i].key == key)
    {
      return assoc[i].val;
    }
  }

  return assoc[0].val;
}

const char *name_of_stone_tool(STONE_TOOL tool)
{
  return search_str_assoc((int)tool, StoneToolName, sizeof(StoneToolName));
}

const char *desc_of_stone_tool(STONE_TOOL tool)
{
  return search_str_assoc((int)tool, StoneToolDesc, sizeof(StoneToolDesc));
}

const char *name_of_lithic_mode(LITHIC_MODE mode)
{
  return search_str_assoc((int)mode, LithicModeName, sizeof(LithicModeName));
}

const char *desc_of_lithic_mode(LITHIC_MODE mode)
{
  return search_str_assoc((int)mode, LithicModeDesc, sizeof(LithicModeDesc));
}

int start_of_lithic_mode(LITHIC_MODE mode)
{
  return search_int_assoc((int)mode,
                          LithicModeEarliest,
                          sizeof(LithicModeEarliest));
}
