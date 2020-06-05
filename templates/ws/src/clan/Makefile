################################################################################
#
# Package @PKG_NAME@ clan makefile.
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
RNMAKE_DIST_PGMS = clan

# Source Files for libpleistocene
clan.SRC.CXX = clan.cxx grammar.cxx lang.cxx troglodyte.cxx utils.cxx

# Libraries to link with
clan.LIBS = pleistocene stdc++

# Libraries within this package this program is dependent upon
clan.LIBDEPS	= pleistocene

#------------------------------------------------------------------------------
# Include RNMAKE top-level rules makefile

include $(RNMAKE_PKG_ROOT)/rnmake/Rules.mk
