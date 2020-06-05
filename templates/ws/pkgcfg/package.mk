################################################################################
#
# The @PKG_NAME@ package-wide makefile.
#
# \LegalBegin
# \LegalEnd
#
################################################################################

export _PKG_MK = 1

ifndef RNMAKE_PKG_ROOT
  $(error 'RNMAKE_PKG_ROOT' Not defined in including makefile)
endif

#------------------------------------------------------------------------------
# The Package Definition
RNMAKE_PKG                 = @PKG_NAME@
RNMAKE_PKG_VERSION_MAJOR   = @PKG_VER_MAJOR@
RNMAKE_PKG_VERSION_MINOR   = @PKG_VER_MINOR@
RNMAKE_PKG_VERSION_RELEASE = @PKG_VER_RELEASE@
RNMAKE_PKG_VERSION_DATE    = @THIS_YEAR@

RNMAKE_PKG_AUTHORS    = @PKG_AUTHOR@
RNMAKE_PKG_OWNERS     = @PKG_OWNER@
RNMAKE_PKG_URL        = @PKG_URL@
RNMAKE_PKG_EMAIL      = @PKG_EMAIL@
RNMAKE_PKG_LICENSE    = @PKG_LICENSE@
RNMAKE_PKG_LOGO       = @PKG_LOGO@
RNMAKE_PKG_FAVICON    = @PKG_FAVICON@
RNMAKE_PKG_DESC       = @PKG_DESC@
RNMAKE_PKG_KEYWORDS   = @PKG_KW@
RNMAKE_PKG_DISCLAIMER = See the @LICENSE_FILE@ for any copyright and licensing information.

# Dotted full version number M.m.r
RNMAKE_PKG_VERSION_DOTTED = $(RNMAKE_PKG_VERSION_MAJOR).$(RNMAKE_PKG_VERSION_MINOR).$(RNMAKE_PKG_VERSION_RELEASE)

# Concatenated full version number Mmr
RNMAKE_PKG_VERSION_CAT = $(RNMAKE_PKG_VERSION_MAJOR)$(RNMAKE_PKG_VERSION_MINOR)$(RNMAKE_PKG_VERSION_RELEASE)

# Package full name name-M.m.r
RNMAKE_PKG_FULL_NAME = $(RNMAKE_PKG)-$(RNMAKE_PKG_VERSION_DOTTED)

# Package documentation home page template.
# Undefined for no home page.
RNMAKE_PKG_HOME_INDEX = @PKG_HOME_PAGE@

#------------------------------------------------------------------------------
# Organization
RNMAKE_ORG         = @ORG@
RNMAKE_ORG_FQ      = @ORG_FQ@
RNMAKE_ORG_ABBREV  = @ORG_ABBREV@
RNMAKE_ORG_URL     = @ORG_URL@
RNMAKE_ORG_LOGO    = @ORG_LOGO@
RNMAKE_ORG_FAVICON = @ORG_FAVICON@

#------------------------------------------------------------------------------
# Package Optional Variables and Tweaks

# Package Include Directories
RNMAKE_PKG_INCDIRS = $(RNMAKE_PKG_ROOT)/src/include

# Package System Include Directories
RNMAKE_PKG_SYS_INCDIRS =

# Package Library Subdirectories
RNMAKE_PKG_LIB_SUBDIRS = @PKG_NAME@

# Link Library Extra Library Directories (exluding local libraries)
RNMAKE_PKG_LD_LIBDIRS = 

# Release Files (docs)
RNMAKE_PKG_REL_FILES = VERSION.txt README.md INSTALL.md LICENSE

# CPP flags
RNMAKE_PKG_CPPFLAGS =

# C flags
RNMAKE_PKG_CFLAGS =

# CXX flags
RNMAKE_PKG_CXXFLAGS =

# Link flags
RNMAKE_PKG_LDFLAGS =

#------------------------------------------------------------------------------
# Package Debian Package Configuration

# Set Debian package default install location. Default default: /usr/local
# RNMAKE_DEB_PREFIX = /some/other/loc

#------------------------------------------------------------------------------
# Package Doxygen Configuration

# Define to build doxygen documentation, undefine or empty to disable.
RNMAKE_DOXY_ENABLED := @DOXY_ENABLED@

# Package doxygen configuration directory.
PKG_DOXY_CONF_DIR = @DOXY_DIR@

# Package doxygen configuration. Doxygen documentation will not be built
# without this file.
RNMAKE_DOXY_CONF_FILE = @DOXY_CONF_FILE@

# Doxygen field: HTML_HEADER
RNMAKE_DOXY_HTML_HEADER = @DOXY_HEADER_FILE@

# Doxygen field: HTML_FOOT
RNMAKE_DOXY_HTML_FOOTER = @DOXY_FOOTER_FILE@

# HTML_HEADER should <link> to this stylesheet 
RNMAKE_DOXY_HTML_STYLESHEET = @DOXY_CSS_FILE@

# All images in this directory are copied to doxygen source image directory
RNMAKE_DOXY_IMAGES = @DOXY_IMAGES_DIR@

# Doxygen field: PROJECT_LOGO
RNMAKE_DOXY_PROJECT_LOGO = @DOXY_LOGO_IMAGE@

#------------------------------------------------------------------------------
# Package Pydoc Configuration

# Define to build python documention, undefine or empty to disable.
# RNMAKE_PYTHON_ENABLED must also be defined in Arch.<arch>.mk makefile.
RNMAKE_PYDOC_ENABLED := @PYDOC_ENABLED@

# Pydoc optional index.html template.
# Undefined if no pydoc index page
RNMAKE_PYDOC_INDEX = @PYDOC_INDEX_FILE@
