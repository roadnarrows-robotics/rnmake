/*! \file
 *
 * \brief Little stone tools for naked apes.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Application,stones}
 * \author @PKG_AUTHOR@ 
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <libgen.h>
#include <getopt.h>
#include <stdio.h>

#include "@PKG_NAME@/stone_tools.h"

/*!
 * \brief Default and parsed command-line argument values structure.
 * */
struct args_t
{
  bool  list_tools;   ///< do [not] list tools info
  bool  list_modes;   ///< do [not] list modes info
};

/*!
 * \brief List Pleistocene stone tools with descriptions.
 */
static void list_tools()
{
  printf("Stone Tools\n");

  for(STONE_TOOL tool=STONE_TOOL_UNKNOWN; tool<NUMOF_STONE_TOOLS; ++tool)
  {
    printf("%-12s %s\n", name_of_stone_tool(tool), desc_of_stone_tool(tool));
  }

  printf("\n");
}

/*!
 * \brief List Pleistocene lithic mode industry information.
 */
static void list_modes()
{
  printf("Lithic Modes\n");

  for(LITHIC_MODE mode=LITHIC_MODE_UNKNOWN; mode<NUMOF_LITHIC_MODES; ++mode)
  {
    printf("%-12s %4dkya %s\n", name_of_lithic_mode(mode),
                                start_of_lithic_mode(mode),
                                desc_of_lithic_mode(mode));
  }

  printf("\n");
}

/*!
 * \brief Print help to stdout.
 *
 * \param argv0   Command name.
 */
static void print_help(const char *argv0)
{
  printf("Usage: %s [OPTIONS]\n", argv0);
  printf("       %s --help\n", argv0);

  printf("\n");
  printf("List information on Pleistocene stone tools used by Homo.\n");

  printf("\n");
  printf(
"Mandatory arguments to long options are mandatory for short options too.\n"
"  -m, --list-modes   List information on stone tools modes of complexity.\n"
"  -t, --list-tools   List information on stone tools used.\n"
"\n"
"  -h, --help         Print this help.\n");
}

/*!
 * \brief Parse command-line options and arguments.
 *
 * \param           argc  Command-line argument count.
 * \param           argv  Command-line argument list.
 * \param [in,out]  pargs Pointer to parsed argument structure.
 */
static void argparse(int argc, char *argv[], struct args_t *pargs)
{
  //
  // Set external getopt_long() variables. N.B. makes OptsGet() non-reentrant.
  //
  optarg  = NULL; // current argument to option
  optind  = 0;    // next index in argv to look for options
  opterr  = 1;    // allow getopt_long() to print error messages
  optopt  = 0;    // current parsed option character
  
  struct option long_options[] = 
  {
    {"list-tools", no_argument, NULL, 't'},
    {"list-modes", no_argument, NULL, 'm'},
    {"help",       no_argument, NULL, 'h'},
    {NULL,         0,           NULL, 0}
  };

  int option_index;
  int c;

  while(true)
  {
    option_index = 0;

    c = getopt_long(argc, argv, "hmt", long_options, &option_index);

    if( c == -1 )
    {
      break;
    }

    switch(c)
    {
      case 'h':
        print_help(basename(argv[0]));
        exit(0);
        break;
      case 'm':
        pargs->list_modes = true;
        break;
      case 't':
        pargs->list_tools = true;
        break;
      case '?':   // error
        exit(2);
        break;
      default:
        fprintf(stderr, "'%c' unexpected", c);
        break;
    }
  }
}

/*!
 * \brief Main.
 *
 * \param argc  Command-line argument count.
 * \param argv  Command-line argument list.
 *
 * \return Returns 0 on success, \h_gt 0 on failure.
 */
int main(int argc, char *argv[])
{
  struct args_t args = {false, false};

  argparse(argc, argv, &args);

  if( args.list_tools )
  {
    list_tools();
  }

  if( args.list_modes )
  {
    list_modes();
  }

  return 0;
}
