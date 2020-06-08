################################################################################
#
# @PKG_NAME@ envirionment makefile
#
# \LegalBegin
# \LegalEnd
#
################################################################################

#$(info DBG: $(lastword $(MAKEFILE_LIST)))

export _PKGCFG_ENV_MK = 1

# must be defined and non-empty
ifndef @ID_PKG_WS@
  $(error '@ID_PKG_WS@' environment variable not specified)
endif

# ------------------------------------------------------------------------------
# RNMAKE_ARCH_DFT
#   Determines default architecture to make.
#
#   Environment variable: @ID_PKG@_ARCH_DFT
#   Fallback default:     x86_64
# ------------------------------------------------------------------------------

# 'make arch=<arch> ...' or @ID_PKG@_ARCH_DFT or x86_64
@ID_PKG@_ARCH_DFT ?= x86_64

# rnmake variable
RNMAKE_ARCH_DFT = $(@ID_PKG@_ARCH_DFT)

# ------------------------------------------------------------------------------
# RNMAKE_INSTALL_XPREFIX
#   Cross-install prefix. Actual packages are installed to:
#   $(RNMAKE_INSTALL_XPREFIX)/$(RNMAKE_ARCH)/
#
#   Environment variable: @ID_PKG@_INSTALL_XPREFIX
#   Fallback default:     $(HOME)/xinstall
# ------------------------------------------------------------------------------

# 'make xprefix=<path> ...' or RNMAKE_INSTALL_XPREFIX
@ID_PKG@_INSTALL_XPREFIX ?= $(HOME)/xinstall

# rnmake variable
RNMAKE_INSTALL_XPREFIX = $(@ID_PKG@_INSTALL_XPREFIX)

# ------------------------------------------------------------------------------
# RNMAKE_INSTALL_PREFIX
#   Install prefix. Overrides RNMAKE_INSTALL_XPREFIX. Packages are installed to:
#   $(RNMAKE_INSTALL_PREFIX)/
#
#   Environment Variable: @ID_PKG@_INSTALL_PREFIX
# ------------------------------------------------------------------------------

# rnmake variable
RNMAKE_INSTALL_PREFIX = $(@ID_PKG@_INSTALL_PREFIX)

# ------------------------------------------------------------------------------
# Export to sub-makes
#
export RNMAKE_ARCH_DFT
export RNMAKE_INSTALL_XPREFIX
export RNMAKE_INSTALL_PREFIX
