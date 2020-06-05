################################################################################
#
# Makefile
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Make the RoadNarrows Make System. Cool.

Make the RN Make System documentation and repo packages. Nothing else to make.

\pkgsynopsis
(Meta) RN Make System

\pkgfile{Makefile}

\pkgauthor{Robin Knight,robin.knight@roadnarrows.com}

\pkgcopyright{2005-2018,RoadNarrows LLC,http://www.roadnarrows.com}

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

#------------------------------------------------------------------------------
# Prelims

# this makefile is last, get the directory part for rnmake root
RNMAKE_ROOT = $(realpath .)

# package root
export RNMAKE_PKG_ROOT = $(RNMAKE_ROOT)

# Include envirionment
include $(RNMAKE_ROOT)/Env.mk

# Include standard collection of functions, etc
include $(RNMAKE_ROOT)/Std.mk

# Include package specificiation
include $(RNMAKE_ROOT)/pkgcfg/package.mk

# Include shell commands.
include $(RNMAKE_ROOT)/Cmds.mk

# Define to not require c/c++ dependencies.
export nodeps = 1

#------------------------------------------------------------------------------
# Overide Rules.mk Targets

# Simple make distro directory structure
.PHONY: all
all: rnbanner
	@$(MAKE) -s -f $(RNMAKE_ROOT)/Rules.mk mkdistdirs copy-src
	$(footer)

# Only install the documentation
.PHONY: install
install: rnbanner
	@$(MAKE) -s -f $(RNMAKE_ROOT)/Rules.mk check-prefix rel install-docs 
						install-src
	$(footer)

# Only make the documentation and source Debian packages
.PHONY: dpkgs
dpkgs: rnbanner all
	@$(MAKE) -s -f $(RNMAKE_ROOT)/Rules.mk dpkg-doc dpkg-src
	$(footer)

# Only make the documentation and source tarballs
.PHONY: tarballs all
tarballs: rnbanner
	@$(MAKE) -s -f $(RNMAKE_ROOT)/Rules.mk tarball-doc tarball-src
	$(footer)

.PHONY: distclean clobber
clean distclean clobber: rnbanner
	@$(MAKE) -s -f $(RNMAKE_ROOT)/Rules.mk $(@)
	@$(FIND) . -type d -name '__pycache__' | $(XARGS) $(RM)
	$(footer)

# required targets not applicable
deps: ;
subdirs-supp-docs: ;


.PHONY: update-legal
update-legal:
	$(RNMAKE_ROOT)/tools/rnupdate_legal --exclude=templates --verbose \
		copyright_initial=2005 \
		copyright_holder="$(RNMAKE_PKG_OWNERS)" \
		url="$(RNMAKE_PKG_URL)" \
		email="$(RNMAKE_PKG_EMAIL)" \
		mit-alt

.PHONY: rnbanner
rnbanner:
	$(call printPkgBanner,$(RNMAKE_PKG_FULL_NAME),any,$(MAKECMDGOALS))

help_tgts =	all install dpkgs tarballs clean distclean update-legal help

.PHONY: help
help:
	@echo '$(help_tgts)'

# last resort rule
%::
	$(call printError,$(@): Unknown target. See 'make help' for help.)

# $(footer)
# 	Conditionally print footer.
footer = $(call printFooter,$(@),$(lasword,$(MAKECMDGOALS)))
