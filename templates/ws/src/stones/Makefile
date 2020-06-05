################################################################################
#
# Package @PKG_NAME@ stones makefile.
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
RNMAKE_DIST_PGMS = stones

# Source Files for libpleistocene
stones.SRC.C = stones.c

# Libraries to link with
stones.LIBS = pleistocene

# Libraries within this package this program is dependent upon
stones.LIBDEPS	= pleistocene

#------------------------------------------------------------------------------
# Include RNMAKE top-level rules makefile

include $(RNMAKE_PKG_ROOT)/rnmake/Rules.mk
