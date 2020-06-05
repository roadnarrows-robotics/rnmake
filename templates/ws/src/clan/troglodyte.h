/*! \file
 *
 * \brief Troglodyte class interface.
 *
 * \pkgfile{@FILENAME@}
 * \pkgcomponent{Application,clan}
 * \author @PKG_AUTHOR@ 
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */

#ifndef _CLAN_TROGLODYTE_H
#define _CLAN_TROGLODYTE_H

#include <string>

namespace clan
{
  /*!
   * \brief Full moon names starting from modern month January.
   */
  enum FullMoon
  {
    WOLF_MOON,          ///< January
    SNOW_MOON,          ///< February
    WORM_MOON,          ///< March
    PINK_MOON,          ///< April
    FLOWER_MOON,        ///< May
    STRAWBERRY_MOON,    ///< June
    BUCK_MOON,          ///< July
    STURGEON_MOON,      ///< August
    CORN_MOON,          ///< September
    HUNTER_MOON,        ///< October
    BEAVER_MOON,        ///< November
    COLD_MOON           ///< Christmas
  };
  
  /*!
   * \brief Get the name of the full moon.
   *
   * \param moon  Full moon enum.
   *
   * \return Reference to full moon's name.
   */ 
  extern const std::string &full_moon_name(const FullMoon moon);
  
  /*
   * \brief Troglodyte class.
   */
  class Troglodyte
  {
  public:
    /*!
     * \brief Sex of cavey.
     */
    enum Sex
    {
      IT      = 0,    ///< what ever
      MALE    = 1,    ///< pointy
      FEMALE  = 2,    ///< encompassing
      FLUID   = 3     ///< defined personally in-the-moment
    };
  
    /*!
     * \brief Get the name of the troglodyte's sex.
     *
     * \param sex Sex enum.
     *
     * \return Reference to sex name.
     */ 
    static const std::string &sex_name(const Sex sex);

    /*!
     * \brief Default constructor.
     */
    Troglodyte() :
        m_name("unknown"), m_sex(Sex::IT), m_age(0), m_birth_moon(COLD_MOON)
    {
    }

    /*!
     * \brief Intialization constructor.
     *
     * \param name
     * \param sex
     * \param age
     * \param birth_moon
     */
    Troglodyte(const std::string name,
               const Troglodyte::Sex sex,
               const int age,
               const FullMoon birth_moon) :
        m_name(name), m_sex(sex), m_age(age), m_birth_moon(birth_moon)
    {
    }
  
    /*!
     * brief Name place-holder constructor.
     *
     * \param name
     */
    Troglodyte(const std::string name) :
        m_name(name), m_sex(Sex::IT), m_age(0), m_birth_moon(COLD_MOON)
    {
    }

    /*!
     * brief Copy constructor.
     *
     * \param src   Source troglodyte.
     */
    Troglodyte(const Troglodyte &src)
    {
      m_name        = src.m_name;
      m_sex         = src.m_sex;
      m_age         = src.m_age; 
      m_birth_moon  = src.m_birth_moon;
    }

    /*!
     * \brief Destructor.
     */
    virtual ~Troglodyte() { }
  
    /*!
     * \brief Equality operator.
     *
     * True of trog names are the same.
     *
     * \param rhs Right hand side object.
     *
     * \return Returns true or false.
     */
    bool operator==(const Troglodyte &rhs) const
    {
      return m_name == rhs.m_name;
    }

    /*!
     * \copydoc clan::Troglodyte::operator==
     */
    bool operator==(const std::string rhs) const
    {
      return m_name == rhs;
    }

    /*!
     * \brief Less than operator.
     *
     * True of this trog name lexically less than poser.
     *
     * \param rhs Right hand side object.
     *
     * \return Returns true or false.
     */
    bool operator<(const Troglodyte &rhs) const
    {
      return m_name < rhs.m_name;
    }

    /*!
     * \copydoc clan::Troglodyte::operator<
     */
    bool operator<(const std::string rhs) const
    {
      return m_name < rhs;
    }

    /*!
     * \brief Retrieve troglodyte's name.
     * \return Returns reference to string.
     */
    const std::string &name() const
    {
      return m_name;
    }

    /*!
     * \brief Retrieve troglodyte's sex.
     * \return Returns Sex enum.
     */
    const Sex sex() const
    {
      return m_sex;
    }

    /*!
     * \brief Retrieve troglodyte's age.
     * \return Returns integer.
     */
    const int age() const
    {
      return m_age;
    }

    /*!
     * \brief Retrieve troglodyte's birth moon.
     * \return Returns birth moon enum.
     */
    const FullMoon birth_moon() const
    {
      return m_birth_moon;
    }

    void activity(const std::string &activity)
    {
      m_activity = activity;
    }

    void idle()
    {
      m_activity.clear();
    }

    /*!
     * \brief Create activity description from current activity.
     *
     * \return Returns string description.
     */
    const std::string whatcha_doin();

  protected:
    std::string m_name;       ///< name of troglodyte
    Sex         m_sex;        ///< sex of the inner beast
    int         m_age;        ///< number of birth moons
    FullMoon    m_birth_moon; ///< birth full moon
    std::string m_activity;   ///< trog's current activity
  };

} // namespace clan

#endif // _CLAN_TROGLODYTE_H
