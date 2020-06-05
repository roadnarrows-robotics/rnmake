################################################################################
#
# @PKG_NAME@ envirionment makefile
#
# \LegalBegin
# \LegalEnd
#
################################################################################

#$(info DBG: $(lastword $(MAKEFILE_LIST)))

export _ENV_MK = 1

# must be defined and non-empty
ifndef @ID_PKG_WS@
  $(error '@ID_PKG_WS@' environment variable not specified)
endif

# ------------------------------------------------------------------------------
# RNMAKE_ARCH_TAG
# 	What:									Determines which architecture makefile to include.
# 													Arch.$(RNMAKE_ARCH_TAG).mk
# 	Environment variable: @ID_PKG@_ARCH_DFT
# 	Make override:				make arch=<arch> ...
# 	Default:							x86_64
# 	Required:							no
# ------------------------------------------------------------------------------

# 'make arch=<arch> ...' or @ID_PKG@_ARCH_DFT or x86_64
@ID_PKG@_ARCH_DFT ?= x86_64
arch ?= $(@ID_PKG@_ARCH_DFT)

RNMAKE_ARCH_TAG := $(arch)


# ------------------------------------------------------------------------------
# RNMAKE_INSTALL_XPREFIX
# 	What:									Cross-install prefix.
# 												Actual packages are installed to
# 	                      	$(RNMAKE_INSTALL_XPREFIX)/$(RNMAKE_ARCH)/
# 	Environment variable: @ID_PKG@_INSTALL_XPREFIX
# 	Make override:				make xprefix=<path> ...
# 	Default:							$(HOME)/xinstall
# 	Required:							no
# ------------------------------------------------------------------------------

# 'make xprefix=<path> ...' or RNMAKE_INSTALL_XPREFIX
@ID_PKG@_INSTALL_XPREFIX ?= $(HOME)/xinstall
xprefix ?= $(@ID_PKG@_INSTALL_XPREFIX)

# make cannonical path (does not have to exist)
RNMAKE_INSTALL_XPREFIX := $(abspath $(xprefix))


# ------------------------------------------------------------------------------
# RNMAKE_INSTALL_PREFIX
# 	What:									Install prefix. Overrides RNMAKE_INSTALL_XPREFIX.
# 												Packages are installed to:
# 													$(RNMAKE_INSTALL_PREFIX)/
# 	Environment variable: @ID_PKG@_INSTALL_PREFIX
# 	Make override:				make prefix=_path_ ...
# 	Default:							
# 	Required:							no
# ------------------------------------------------------------------------------

# 'make prefix=<path> ...' or @ID_PKG@_INSTALL_PREFIX
prefix ?= $(@ID_PKG@_INSTALL_PREFIX)

# make cannonical path (does not have to exist)
RNMAKE_INSTALL_PREFIX := $(abspath $(prefix))


# ------------------------------------------------------------------------------
# Export to sub-makes
#
export RNMAKE_ARCH_TAG
export RNMAKE_INSTALL_XPREFIX
export RNMAKE_INSTALL_PREFIX
