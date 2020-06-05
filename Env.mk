################################################################################
#
# Env.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief The rnmake system command-line and environment variables helper makefile.

\pkgsynopsis
RN Make System.

\pkgfile{Env.mk}

\pkgauthor{Robin Knight,robin.knight@roadnarrows.com}

\pkgcopyright{2020,RoadNarrows LLC,http://www.roadnarrows.com}

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

#$(info DBG: $(lastword $(MAKEFILE_LIST)))

export _ENV_MK = 1

# ------------------------------------------------------------------------------
# RNMAKE_ARCH_TAG
#   What:                 Determines which architecture makefile to include.
#                         Arch.$(RNMAKE_ARCH_TAG).mk
#   Environment variable: RNMAKE_ARCH_DFT
#   Make override:        make arch=<arch> ...
#   Default:              x86_64
#   Required:             no
# ------------------------------------------------------------------------------

# 'make arch=<arch> ...' or RNMAKE_ARCH_DFT
arch ?= $(RNMAKE_ARCH_DFT)

# command-line variable=value cannot be modified
_arch = $(arch)

# default default
ifndef _arch
  _arch = x86_64
  $(info 'arch=$(_arch)' default default used.)
endif

RNMAKE_ARCH_TAG := $(_arch)

undefine _arch

# ------------------------------------------------------------------------------
# RNMAKE_INSTALL_XPREFIX
#   What:                 Cross-install prefix.
#                         Actual packages are installed to
#                           $(RNMAKE_INSTALL_XPREFIX)/$(RNMAKE_ARCH)/
#   Environment variable: RNMAKE_INSTALL_XPREFIX
#   Make override:        make xprefix=<path> ...
#   Default:              $(HOME)/xinstall
#   Required:             no
# ------------------------------------------------------------------------------

# 'make xprefix=<path> ...' or RNMAKE_INSTALL_XPREFIX
xprefix ?= $(RNMAKE_INSTALL_XPREFIX)

# command-line variable=value cannot be modified
_xprefix = $(xprefix)

# default default
ifndef _xprefix
  _xprefix = $(HOME)/xinstall
  $(info 'RNMAKE_INSTALL_XPREFIX=$(_xprefix)' default default used.)
endif

# make cannonical path (does not have to exist)
RNMAKE_INSTALL_XPREFIX := $(abspath $(_xprefix))

undefine _xprefix

# ------------------------------------------------------------------------------
# RNMAKE_INSTALL_PREFIX
#   What:                 Install prefix. Overrides RNMAKE_INSTALL_XPREFIX.
#                         Packages are installed to:
#                           $(RNMAKE_INSTALL_PREFIX)/
#   Environment variable: RNMAKE_INSTALL_PREFIX
#   Make override:        make prefix=<path> ...
#   Default:              
#   Required:             no
# ------------------------------------------------------------------------------

# 'make prefix=<path> ...' or RNMAKE_INSTALL_PREFIX
prefix ?= $(RNMAKE_INSTALL_PREFIX)

# command-line variable=value cannot be modified
_prefix = $(prefix)

# make cannonical path (does not have to exist)
ifdef _prefix
  RNMAKE_INSTALL_PREFIX := $(abspath $(_prefix))
endif

undefine _prefix

# ------------------------------------------------------------------------------
# Export to sub-makes
#
export RNMAKE_ARCH_TAG
export RNMAKE_INSTALL_XPREFIX
export RNMAKE_INSTALL_PREFIX

ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
