################################################################################
#
# Rules.tarball.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Make Debian repo packages for a package.

This file is automatically included by \ref Rules.mk when one or more of the
Debian make goals are specified.

\pkgsynopsis
RN Make System

\pkgfile{Rules.tarball.mk}

\pkgauthor{Daniel Packard,daniel@roadnarrows.com}
\pkgauthor{Robin Knight,robin.knight@roadnarrows.com}

\pkgcopyright{2009-2018,RoadNarrows LLC,http://www.roadnarrows.com}

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

export _RULES_TARBALL_MK = 1

# binary tarball stem (basename without any extensions)
TARBALL_BIN_STEM = $(RNMAKE_PKG_FULL_NAME)-$(RNMAKE_ARCH)

# tarball file basenames for source, documentation, and binary
TARBALL_SRC_NAME = $(RNMAKE_PKG_FULL_NAME)-src.tar.gz
TARBALL_DOC_NAME = $(RNMAKE_PKG_FULL_NAME)-doc.tar.gz
TARBALL_BIN_NAME = $(TARBALL_BIN_STEM).tar.gz

# binary tarball temporary staging directory
DISTDIR_TMP_TARBALL_BIN = $(DISTDIR_TMP)/$(TARBALL_BIN_STEM)

TARUP = $(TAR)
#TARUP = $(TAR_VERBOSE)

# make all tarball archives
tarballs: pkg-banner tarballs-echo tarball-bin tarball-doc tarball-src
	$(footer)

.PHONY: tarballs-echo
tarballs-echo:
	$(call printGoalWithDesc,$(@),Make all compressed tarballs)

# make documentation tarball archive
.PHONY: tarball-doc
tarball-doc: pkg-banner
	$(printCurGoal)
	$(if $(call isDir,$(DISTDIR_DOC)),,\
			    					$(error No documentation - Try 'make documents' first.))
	@cd $(DIST_ARCH)/doc; \
	$(TARUP) $(DISTDIR_REPO)/$(TARBALL_DOC_NAME) $(RNMAKE_PKG_FULL_NAME)-doc
	@printf "$(DISTDIR_REPO)/$(TARBALL_DOC_NAME)\n"
	$(footer)

# make source tarball archive
.PHONY: tarball-src
tarball-src: pkg-banner echo-tarball-src copy-src
	@cd $(DIST_ARCH)/src; \
	$(TARUP) $(DISTDIR_REPO)/$(TARBALL_SRC_NAME) $(RNMAKE_PKG_FULL_NAME)
	@printf "$(DISTDIR_REPO)/$(TARBALL_SRC_NAME)\n"
	$(footer)

# make binary tarball archive
.PHONY: tarball-bin
tarball-bin: pkg-banner
	$(printCurGoal)
	$(if $(call isFile,$(DIST_ARCH)/all.done),,\
		$(error Nothing/incomplete make - Try 'make all' first at package root.))
	@test -d $(DISTDIR_TMP_TARBALL_BIN) || $(MKDIR) $(DISTDIR_TMP_TARBALL_BIN)
	@cd $(DIST_ARCH); \
	$(FIND) bin lib include etc share -print | \
	while read src; \
	do \
		if [ -f $$src ]; \
		then \
			$(RNMAKE_ROOT)/utils/cppath.sh $$src $(DISTDIR_TMP_TARBALL_BIN); \
		fi; \
	done;
	@cd $(DIST_ARCH)/tmp; \
	$(TARUP) $(DISTDIR_REPO)/$(TARBALL_BIN_NAME) $(TARBALL_BIN_STEM)
	@printf "$(DISTDIR_REPO)/$(TARBALL_BIN_NAME)\n"
	$(footer)


ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
