################################################################################
#
# Rules.dpkg.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Make Debian repo packages for a package.

This file is automatically included by \ref Rules.mk when one or more of the
Debian make goals are specified.

\pkgsynopsis
RN Make System

\pkgfile{Rules.dpkg.mk}

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

export _RULES_DPKG_MK = 1

# Debian package install prefix
RNMAKE_DEB_PREFIX ?= /usr/local

# Debian configuration directories for development, source, and documentation
DEB_CONF_DEV = $(RNMAKE_PKG_ROOT)/pkgcfg/deb-dev
DEB_CONF_SRC = $(RNMAKE_PKG_ROOT)/pkgcfg/deb-src
DEB_CONF_DOC = $(RNMAKE_PKG_ROOT)/pkgcfg/deb-doc

# Debian package file basenames for development, source, and documentation
DEB_PKG_DEV_NAME = $(RNMAKE_PKG)-dev-$(RNMAKE_PKG_VERSION_DOTTED)
DEB_PKG_SRC_NAME = $(RNMAKE_PKG)-src-$(RNMAKE_PKG_VERSION_DOTTED)
DEB_PKG_DOC_NAME = $(RNMAKE_PKG)-doc-$(RNMAKE_PKG_VERSION_DOTTED)

# temporary staging directories
DISTDIR_TMP_DEB	    = $(DISTDIR_TMP)/deb
DISTDIR_TMP_DEB_DEV = $(DISTDIR_TMP_DEB)/$(DEB_PKG_DEV_NAME)
DISTDIR_TMP_DEB_SRC = $(DISTDIR_TMP_DEB)/$(DEB_PKG_SRC_NAME)
DISTDIR_TMP_DEB_DOC = $(DISTDIR_TMP_DEB)/$(DEB_PKG_DOC_NAME)

# usefule message
MSG_SKIP := Debian configuration directory not found. Skipping

# include standard set of functions if not already included
ifndef _STD_MK
  $(eval include $(RNMAKE_ROOT)/Std.mk)
endif

# include document rules if not already included
ifndef _RULES_DOC_MK
  $(eval include $(RNMAKE_ROOT)/Rules.doc.mk)
endif

dpkgs: pkg-banner dpkgs-echo dpkg-dev dpkg-src dpkg-doc
	$(footer)

.PHONY: dpkgs-echo
dpkgs-echo:
	$(call printGoalWithDesc,$(@),Make all debian packages)

.PHONY: dpkg-dev
dpkg-dev: pkg-banner all echo-dpkg-dev
	$(if $(call isDir, $(DEB_CONF_DEV)),\
		$(shell $(RNMAKE_ROOT)/utils/dpkg-helper.sh \
			-a $(RNMAKE_ARCH) \
			-c $(DEB_CONF_DEV) \
			-d $(DIST_ARCH) \
			-t $(DISTDIR_TMP_DEB_DEV) \
			-n $(DEB_PKG_DEV_NAME) \
			-p $(RNMAKE_DEB_PREFIX) \
			-v $(RNMAKE_PKG_VERSION_DOTTED) \
			-y pkgtype-dev \
			1>&2 \
	 	),\
		$(call printInfo,$(DEB_CONF_DEV): $(MSG_SKIP)))
	$(footer)
	
.PHONY: dpkg-src
dpkg-src: pkg-banner echo-dpkg-src copy-src
	$(if $(call isDir, $(DEB_CONF_SRC)),\
		$(shell $(RNMAKE_ROOT)/utils/dpkg-helper.sh \
			-a $(RNMAKE_ARCH) \
			-c $(DEB_CONF_SRC) \
			-d $(DIST_ARCH) \
			-t $(DISTDIR_TMP_DEB_SRC) \
			-n $(DEB_PKG_SRC_NAME) \
			-p $(RNMAKE_DEB_PREFIX) \
			-v $(RNMAKE_PKG_VERSION_DOTTED) \
			-y pkgtype-src \
			1>&2 \
	 	),\
		$(call printInfo $(DEB_CONF_SRC): $(MSG_SKIP)))
	$(footer)

.PHONY: dpkg-doc
dpkg-doc: pkg-banner documents echo-dpkg-doc
	$(if $(call isDir, $(DEB_CONF_DOC)),\
		$(shell $(RNMAKE_ROOT)/utils/dpkg-helper.sh \
			-a $(RNMAKE_ARCH) \
			-c $(DEB_CONF_DOC) \
			-d $(DIST_ARCH) \
			-t $(DISTDIR_TMP_DEB_DOC) \
			-n $(DEB_PKG_DOC_NAME) \
			-p $(RNMAKE_DEB_PREFIX) \
			-v $(RNMAKE_PKG_VERSION_DOTTED) \
			-y pkgtype-doc \
			1>&2 \
	 	),\
		$(call printInfo $(DEB_CONF_DOC): $(MSG_SKIP)))
	$(footer)


ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
