################################################################################
#
# Package @PKG_NAME@ source makefile.
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
# Scripts

SCRIPTS = ooga_chant.sh @PYTHON_SCRIPTS@

EXTRA_TGT_ALL = all-scripts

.PHONY: all-scripts
all-scripts: echo-all-scripts
	$(call copyTrees,$(SCRIPTS),$(DISTDIR_BIN))


#------------------------------------------------------------------------------
# Include RNMAKE rules makefile(s)

include $(RNMAKE_PKG_ROOT)/rnmake/Rules.mk
