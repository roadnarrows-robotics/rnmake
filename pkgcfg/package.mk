################################################################################
#
# pkgcfg/package.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief RoadNarrows Make System rnmake package master (meta) makefile.

\pkgsynopsis
(Meta) RN Make System

\pkgfile{pkgcfg/package.mk}

\pkgauthor{Robin Knight,robin.knight@roadnarrows.com}

\pkgcopyright{2005-2020,RoadNarrows LLC,http://www.roadnarrows.com}

\LegalBegin
Copyright (c) 2005-2020 RoadNarrows LLC

Licensed under the MIT License (the "License").

You may not use this file except in compliance with the License. You may
obtain a copy of the License at:

https://opensource.org/licenses/MIT

The software is provided "AS IS", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. in no event shall the
authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising from,
out of or in connection with the software or the use or other dealings in the
software.
\LegalEnd

\cond RNMAKE_DOXY
 */
endif
#
################################################################################

export _PKG_MK = 1

ifndef RNMAKE_PKG_ROOT
  $(error 'RNMAKE_PKG_ROOT' Not defined in including makefile)
endif

#------------------------------------------------------------------------------
# The Package Definition
RNMAKE_PKG                 = rnmake
RNMAKE_PKG_VERSION_MAJOR   = 4
RNMAKE_PKG_VERSION_MINOR   = 0
RNMAKE_PKG_VERSION_RELEASE = 1
RNMAKE_PKG_VERSION_DATE    = 2020

RNMAKE_PKG_AUTHORS    = Robin Knight
RNMAKE_PKG_OWNERS     = RoadNarrows LLC
RNMAKE_PKG_URL        = https://github.com/roadnarrows-roboitics/rnmake
RNMAKE_PKG_EMAIL      = robin.knight@roadnarrows.com
RNMAKE_PKG_LICENSE    = MIT
RNMAKE_PKG_LOGO       = $(RNMAKE_PKG_ROOT)/doxy/rn_images/RNLogo.png
RNMAKE_PKG_FAVICON    = $(RNMAKE_PKG_ROOT)/doxy/rn_images/favicon.png
RNMAKE_PKG_DESC       = RoadNarrows Robotics make system
RNMAKE_PKG_KEYWORDS   = RoadNarrows, robotics, GNU make
RNMAKE_PKG_DISCLAIMER = See the EULA.md for any copyright and licensing information.

# Dotted full version number M.m.r
RNMAKE_PKG_VERSION_DOTTED = $(RNMAKE_PKG_VERSION_MAJOR).$(RNMAKE_PKG_VERSION_MINOR).$(RNMAKE_PKG_VERSION_RELEASE)

# Concatenated full version number Mmr
RNMAKE_PKG_VERSION_CAT = $(RNMAKE_PKG_VERSION_MAJOR)$(RNMAKE_PKG_VERSION_MINOR)$(RNMAKE_PKG_VERSION_RELEASE)

# Package full name name-M.m.r
RNMAKE_PKG_FULL_NAME = $(RNMAKE_PKG)-$(RNMAKE_PKG_VERSION_DOTTED)

# Package documentation home page template.
# Undefined for no home page.
RNMAKE_PKG_HOME_INDEX = 

#------------------------------------------------------------------------------
# Organization
RNMAKE_ORG         = RoadNarrows
RNMAKE_ORG_FQ      = RoadNarrows LLC
RNMAKE_ORG_ABBREV  = RN
RNMAKE_ORG_URL     = https://www.roadnarrows.com
RNMAKE_ORG_LOGO    = $(RNMAKE_PKG_LOGO)
RNMAKE_ORG_FAVICON = $(RNMAKE_PKG_FAVICON)

#------------------------------------------------------------------------------
# Debian Package

RNMAKE_DEB_PREFIX = /opt

#------------------------------------------------------------------------------
# Package Optional Variables and Tweaks

# Package Include Directories
RNMAKE_PKG_INCDIRS =

# Package System Include Directories
RNMAKE_PKG_SYS_INCDIRS =

# Package Library Subdirectories
RNMAKE_PKG_LIB_SUBDIRS =

# Link Library Extra Library Directories (exluding local libraries)
RNMAKE_PKG_LD_LIBDIRS = 

# Release Files (docs)
RNMAKE_PKG_REL_FILES = VERSION.txt README.md EULA.md

#------------------------------------------------------------------------------
# Package Doxygen Configuration

# Define to build doxygen documentation, undefine or empty to disable.
RNMAKE_DOXY_ENABLED := y

PKG_DOXY_CONF_DIR = $(RNMAKE_ROOT)/doxy/rn_doxy

RNMAKE_DOXY_CONF_FILE = $(RNMAKE_ROOT)/pkgcfg/doxy/doxy.conf

RNMAKE_DOXY_HTML_HEADER     = $(PKG_DOXY_CONF_DIR)/rn_doxy_header.html
RNMAKE_DOXY_HTML_FOOTER     = $(PKG_DOXY_CONF_DIR)/rn_doxy_footer.html
RNMAKE_DOXY_HTML_STYLESHEET = $(PKG_DOXY_CONF_DIR)/rn_doxy.css
RNMAKE_DOXY_IMAGES          = $(RNMAKE_ROOT)/doxy/rn_images
RNMAKE_DOXY_PROJECT_LOGO    = $(RNMAKE_DOXY_IMAGES)/RNLogo.png

#------------------------------------------------------------------------------
# Package Pydoc Configuration

RNMAKE_PYDOC_ENABLED := n
