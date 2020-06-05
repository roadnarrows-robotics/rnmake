/*! \file
 *
 * \brief A hard interface for stone tools.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Library,libpleistocene}
 * \author @PKG_AUTHOR@ 
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#ifndef _@ID_PKG@_STONE_TOOLS_H
#define _@ID_PKG@_STONE_TOOLS_H

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

/*!
 * \brief Stone tool types.
 */
typedef enum
{
  STONE_TOOL_UNKNOWN,       ///< undefined tool

  STONE_TOOL_HAMMERSTONE,   ///< hard cobble to strike a tool stone
  STONE_TOOL_CORE,          ///< tool stone remnant
  STONE_TOOL_FLAKE,         ///< multitool and/or discards
  STONE_TOOL_HAND_AXE,      ///< handheld axe, no shaft
  STONE_TOOL_BLADE,         ///< long narrow flake blades
  STONE_TOOL_POINT,         ///< points affixed to spears, arrows, etc
  STONE_TOOL_AWL,           ///< punch tool to perforate hides
  STONE_TOOL_SCRAPPER,      ///< scrapper to prepare hides and wood
  STONE_TOOL_BURIN,         ///< handheld lithic engraving flake 
  STONE_TOOL_QUERN,         ///< lower, stationary stone for hand-grinding
  STONE_TOOL_MULLER,        ///< upper, mobile handstone for hand-grinding

  NUMOF_STONE_TOOLS         ///< number of tools including unknown
} STONE_TOOL;

/*!
 * \brief Classification levels of stone tool complexity.
 */
typedef enum
{
  LITHIC_MODE_UNKNOWN,      ///< undefined mode

  LITHIC_MODE_PRE_I,        ///< 3.5 mya
  LITHIC_MODE_I,            ///< 2.6 mya
  LITHIC_MODE_II,           ///< 1.7 mya
  LITHIC_MODE_III,          ///< 160 kya
  LITHIC_MODE_IV,           ///< 50 kya
  LITHIC_MODE_V,            ///< 35 kya

  NUMOF_LITHIC_MODES        ///< number of modes including unknown
} LITHIC_MODE;

/*!
 * \brief Retrieve name of the stone tool.
 *
 * \param tool  Stone tool enum.
 *
 * \return
 * Returns null-terminated string name of the tool.
 */
extern const char *name_of_stone_tool(STONE_TOOL tool);

/*!
 * \brief Retrieve the description of the stone tool.
 *
 * \param tool  Stone tool enum.
 *
 * \return
 * Returns null-terminated string short description of the tool.
 */
extern const char *desc_of_stone_tool(STONE_TOOL tool);

/*!
 * \brief Retrieve name of the lithic mode.
 *
 * \param mode  Lithic mode enum.
 *
 * \return
 * Returns null-terminated string name of the mode.
 */
extern const char *name_of_lithic_mode(LITHIC_MODE mode);

/*!
 * \brief Retrieve the description of the lithic mode.
 *
 * \param mode  Lithic mode enum.
 *
 * \return
 * Returns null-terminated string short description of the mode.
 */
extern const char *desc_of_lithic_mode(LITHIC_MODE mode);

/*!
 * \brief Retrieve the earliest appearance in the record of the lithic mode.
 *
 * \param mode  Lithic mode enum.
 *
 * \return
 * Returns kilo years ago date.
 */
extern int start_of_lithic_mode(LITHIC_MODE mode);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // _@ID_PKG@_STONE_TOOLS_H
