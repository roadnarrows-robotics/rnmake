################################################################################
#
# Package @PKG_NAME@ libpleistocene makefile.
#
# RN Make System Specific Makefile
#
# \LegalBegin
# \LegalEnd
# 
################################################################################

#------------------------------------------------------------------------------
# RNMAKE_PKG_ROOT

ifeq ($(@ID_PKG_WS@),)
  $(error '@ID_PKG_WS@' environment variable not specified)
endif

# Package Root Directory
RNMAKE_PKG_ROOT = $(@ID_PKG_WS@)

#------------------------------------------------------------------------------
# Libraries

# Distribution Static Libraries
RNMAKE_DIST_STLIBS = pleistocene

# Distribution Shared Libraries
RNMAKE_DIST_SHLIBS = pleistocene

# Target subdirectory for libraries
pleistocene.SUBDIR = @PKG_NAME@

# Source Files for libpleistocene
pleistocene.SRC.C = fire.c stone_tools.c

# Libraries to link with
pleistocene.LIBS	= 

# libraries within this package this library is dependent upon
pleistocene.LIBDEPS	=

#------------------------------------------------------------------------------
# Include RNMAKE top-level rules makefile

include $(RNMAKE_PKG_ROOT)/rnmake/Rules.mk
