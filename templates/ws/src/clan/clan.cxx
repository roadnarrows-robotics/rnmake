/*! \file
 *
 * \brief Clan application main.
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
#include <vector>
#include <iostream>
#include <iomanip>

#include <stdlib.h>
#include <libgen.h>
#include <unistd.h>
#include <getopt.h>

#include "utils.h"
#include "troglodyte.h"
#include "grammar.h"
#include "lang.h"

using namespace clan;
using namespace clan::troglodese;

/*!
 * \brief Default/parsed command-line argument values structure.
 * */
struct args_t
{
  bool  debug;      ///< debug 
  bool  verbose;    ///< observe plus extraneous information printed
  float iod;        ///< inter-observation delay (seconds);
  int   num_steps;  ///< number of simulation steps
};

/*!
 * \brief Clan type
 */
typedef std::map<std::string, Troglodyte> Clan;

/*! Helper macro */
#define TROG_ELEM(_name, _sex, _age, _moon) \
  _name, Troglodyte(_name, _sex, _age, _moon)

/*!
 * \brief The Clan of the Cave Cricket.
 */
static Clan TheClan =
{
  {TROG_ELEM("Thag B. Caveman", Troglodyte::Sex::MALE, 24, WOLF_MOON)},
  {TROG_ELEM("Ogg", Troglodyte::Sex::MALE, 17, STRAWBERRY_MOON)},
  {TROG_ELEM("Nogga Ya", Troglodyte::Sex::FEMALE, 20, BEAVER_MOON)},
  {TROG_ELEM("Mook", Troglodyte::Sex::FEMALE, 22, FLOWER_MOON)},
  {TROG_ELEM("Thung", Troglodyte::Sex::FEMALE, 1, WORM_MOON)},
  {TROG_ELEM("Krell", Troglodyte::Sex::MALE, 2, WORM_MOON)},
  {TROG_ELEM("Oog the Great", Troglodyte::Sex::MALE, 28, PINK_MOON)},
  {TROG_ELEM("Izz", Troglodyte::Sex::FEMALE, 19, BUCK_MOON)},
  {TROG_ELEM("Bitey", Troglodyte::Sex::MALE, 6, STURGEON_MOON)},
  {TROG_ELEM("Eet Bugs", Troglodyte::Sex::FEMALE, 7, CORN_MOON)},
  {TROG_ELEM("Gums", Troglodyte::Sex::FEMALE, 29, SNOW_MOON)},
  {TROG_ELEM("Old Wink", Troglodyte::Sex::MALE, 31, HUNTER_MOON)},
  {TROG_ELEM("Old Old Wink", Troglodyte::Sex::MALE, 32, COLD_MOON)}
};

/*! Cute name, yes? */
static std::string TheClanName("Clan of the Cave Cricket");

/*!
 * \brief Add clan proper names to (sub)groups of the grammar.
 *
 * \param grammar The grammar.
 *
 * \return Returns true on success, false otherwise.
 */
static bool add_clan_to_grammar(Grammar &grammar)
{
  StrVec clan, adults, children, babies;

  for(Clan::iterator it=TheClan.begin(); it!=TheClan.end(); ++it)
  {
    Troglodyte &trog = it->second;
    clan.push_back(trog.name());
    if( trog.age() >= 14 )
    {
      adults.push_back(trog.name());
    }
    else if( trog.age() >= 4 )
    {
      children.push_back(trog.name());
    }
    else
    {
      babies.push_back(trog.name());
    }
  }

  bool  ok = true;

  ok = ok && grammar.add_symbol(Grammar::ESVO::SUBJECT, "CLAN", clan);
  ok = ok && grammar.add_symbol(Grammar::ESVO::SUBJECT, "ADULTS", adults);
  ok = ok && grammar.add_symbol(Grammar::ESVO::SUBJECT, "URCHINS", children);
  ok = ok && grammar.add_symbol(Grammar::ESVO::SUBJECT, "CAVIES", babies);

  return ok;
}

/*!
 * \brief Preprocess the grammar to add situational components.
 *
 * \param grammar The grammar.
 *
 * \return Returns true on success, false otherwise.
 */
static bool preprocess_grammar(Grammar &grammar)
{
  bool ok = true;

  if( !add_clan_to_grammar(grammar) )
  {
    ok = false;
  }
  else if( !troglodese::add_stone_tools(grammar) )
  {
    ok = false;
  }
  else if( !troglodese::add_fire(grammar) )
  {
    ok = false;
  }

  return ok;  // or not
}

/*!
 * \brief Dump grammar definition to stdout.
 *
 * \param grammar   The grammar.
 */
static void dump_grammar(Grammar &grammar)
{
  std::string indent("      ");

  std::cout << std::endl;
  std::cout << indent << grammar.language() << " Symbol Dictionary"
    << std::endl;
  grammar.print_symbols();

  std::cout << std::endl;
  std::cout << indent << grammar.language() << " Production Rules" << std::endl;
  grammar.print_rules();

  //std::cout << std::endl;
  //std::cout << indent << grammar.language() << " Grammar Tree" << std::endl;
  //grammar.print_tree();
}

/*!
 * \brief Make indirect index of the clan.
 *
 * \param [in,out] vec    Indirect index vector.
 */
static void index_the_clan(StrVec &vec)
{
  for(Clan::iterator it=TheClan.begin(); it!=TheClan.end(); ++it)
  {
    vec.push_back(it->first);
  }
}

static void update_trog(const std::string &activity)
{
  for(Clan::iterator it=TheClan.begin(); it!=TheClan.end(); ++it)
  {
    Troglodyte &trog = it->second;

    if( trog.name() == activity )
    {
      trog.idle();
      return;
    }
    else if( activity.find(trog.name()) == 0 )
    {
      trog.activity(activity);
      return;
    }
  }
}

static void list_clan_activities()
{
  for(Clan::iterator it=TheClan.begin(); it!=TheClan.end(); ++it)
  {
    std::cout << it->second.whatcha_doin() << std::endl;
  }
}

/*!
 * \brief Run clan simulation.
 *
 * \param args  Command-line argumets to control simulation.
 *
 * \return Returns 0 on success, non-zero on failure.
 */
static int run_sim(args_t &args)
{
  Grammar troglodese;

  if( !preprocess_grammar(troglodese) )
  {
    std::cerr << "error: preprocessing grammar '" << Troglodese.name
              << "' failed" << std::endl;
    return 8;
  }

  if( !troglodese.load(Troglodese.name, Troglodese.symbols, Troglodese.rules) )
  {
    std::cerr << "error: loading grammar '" << Troglodese.name << "' failed"
              << std::endl;
    return 8;
  }

  if( args.debug )
  {
    dump_grammar(troglodese);
  }

  if( args.num_steps <= 0 )
  {
    std::cout << std::endl;
    std::cout << "no simulation" << std::endl;
    return 0;
  }

  unsigned iod = (unsigned)(args.iod * 1'000'000);

  if( args.verbose )
  {
    std::cout << std::endl;
    std::cout << "Shh. Observing the clan for " << args.num_steps
              << " time steps." << std::endl;
  }

  for(int i=0; i<args.num_steps; ++i)
  {
    const std::string activity = troglodese.random_sentence();

    update_trog(activity);

    if( args.verbose )
    {
      std::cout << std::setw(3) << std::right << i << ". " << std::setw(0);
    }
    std::cout << activity << "." << std::endl;

    usleep(iod);
  }

  if( args.verbose )
  {
    std::cout << std::endl;
    std::cout << "And that's a slice in the short lives of the "
              << TheClanName << "." << std::endl;
    std::cout << std::endl;

    usleep(1'000'000);
    std::cout << "As we part ways. let's take a final peek." << std::endl;

    list_clan_activities();

    return 0;
  }
}

/*!
 * \brief List clan.
 */
static void list_clan()
{
  std::cout << "    " << TheClanName << std::endl;

  std::cout << std::setw(18) << std::left << "Name" << "  ";
  std::cout << std::setw(6) << std::left << "Sex" << "  ";
  std::cout << std::setw(3) << std::right << "Age" << "  ";
  std::cout << "Birth Moon" << std::endl;

  char prev = std::cout.fill('-');
  std::cout << std::setw(18) << std::left << "" << "  ";
  std::cout << std::setw(6) << std::left << "" << "  ";
  std::cout << std::setw(3) << std::right << "" << "  ";
  std::cout << "----------" << std::endl;
  std::cout.fill(prev);

  for(Clan::iterator it=TheClan.begin(); it!=TheClan.end(); ++it)
  {
    Troglodyte &trog = it->second;
    std::cout << std::setw(18) << std::left << trog.name() << "  ";
    std::cout << std::setw(6) << std::left << Troglodyte::sex_name(trog.sex())
      << "  ";
    std::cout << std::setw(3) << std::right << trog.age() << "  ";
    std::cout << full_moon_name(trog.birth_moon()) << std::endl;
  }
}

/*!
 * \brief Print help to cout.
 *
 * \param argv0   Command name.
 */
static void print_help(const char *argv0)
{
  std::cout << "Usage: " << argv0 << " [OPTIONS] [STEPS]" << std::endl;
  std::cout << "       " << argv0 << " --help" << std::endl;

  std::cout << std::endl;
  std::cout << "Simulate the life of a cave clan." << std::endl;

  std::cout << R"(
Mandatory arguments to long options are mandatory for short options too.
  -c, --cut-to-the-chase  Only output observations with no supporting
                          information. Useful if output is redirected to an
                          application.

  -d, --debug             Debug printing.

      --iod=SECONDS       Inter-observation delay (seconds).
                          Default: 0.15

  -h, --help              Print this help.
)";

  std::cout << R"(
STEPS specifies the number of steps to observe the stimulating life of the
Clan of the Cave Cricket. Default is 10 steps.
)";
}

/*!
 * \brief Parse command-line options and arguments.
 *
 * \param           argc  Command-line argument count.
 * \param           argv  Command-line argument list.
 * \param [in,out]  pargs Pointer to parsed argument structure.
 */
static void argparse(int argc, char *argv[], struct args_t &args)
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
    {"debug",             no_argument,        NULL,   'd'},
    {"cut-to-the-chase",  no_argument,        NULL,   'c'},
    {"help",              no_argument,        NULL,   'h'},
    {"iod",               required_argument,  NULL,   'i'},
    {NULL,                0,                  NULL,   0}
  };

  int option_index;
  int c;

  while(true)
  {
    option_index = 0;

    c = getopt_long(argc, argv, "hdc", long_options, &option_index);

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
      case 'd':
        args.debug = true;
        break;
      case 'c':
        args.verbose = false;
        break;
      case 'i':
        args.iod = std::stof(optarg);
        if( args.iod < 0.0 )
        {
          args.iod = 0.0;
        }
        break;
      case '?':   // error
        exit(2);
        break;
      default:
        std::cerr << c << " unexpected" << std::endl;
        break;
    }
  }

  if( optind < argc )
  {
    args.num_steps = std::stoi(argv[optind]);
  }
}

int main(int argc, char *argv[])
{
  struct args_t args = {false, true, 0.15, 10};

  argparse(argc, argv, args);

  if( args.verbose )
  {
    list_clan();
  }

  return( run_sim(args) );
}
