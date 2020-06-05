################################################################################
#
# Rules.doc.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Make package documentation.

This file is automatically included by \ref Rules.mk when one or more of the
documentation make goals are specified.

\pkgsynopsis RN Make System
\pkgcomponent{Library,libstonetools}
\pkgfile{Rules.doc.mk}
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

#$(info DBG: $(lastword $(MAKEFILE_LIST)))

export _RULES_DOC_MK = 1

# rnmake fixed defaults
RN_DOXY_VER   		=	1.8
RN_DOXY_CONF_DIR 	= $(RNMAKE_ROOT)/doxy
RN_DOXY_STYLE_DIR = $(RN_DOXY_CONF_DIR)/$(RN_DOXY_VER)
RN_DOXY_IMG_DIR 	= $(RN_DOXY_CONF_DIR)/rn_images

# doxygen configuration file
ifndef RNMAKE_DOXY_CONF_FILE
RNMAKE_DOXY_CONF_FILE = $(RN_DOXY_STYLE_DIR)/rn_doxy.conf
endif

# doxygen field: HTML_HEADER
ifndef RNMAKE_DOXY_HTML_HEADER
RNMAKE_DOXY_HTML_HEADER = $(RN_DOXY_STYLE_DIR)/rn_doxy_header.html
endif

# doxygen field: HTML_FOOTER
ifndef RNMAKE_DOXY_HTML_FOOTER
RNMAKE_DOXY_HTML_FOOTER = $(RN_DOXY_STYLE_DIR)/rn_doxy_footer.html
endif

# HTML_HEADER should <link> to this stylesheet 
ifndef RNMAKE_DOXY_HTML_STYLESHEET
RNMAKE_DOXY_HTML_STYLESHEET = $(RN_DOXY_STYLE_DIR)/rn_doxy.css
endif

# all images in this directory are copied to doxygen source image directory
ifndef RNMAKE_DOXY_IMAGES
RNMAKE_DOXY_IMAGES = $(RN_DOXY_CONF_DIR)/rn_images
endif

# doxygen field: PROJECT_LOGO
ifndef RNMAKE_DOXY_PROJECT_LOGO
RNMAKE_DOXY_PROJECT_LOGO = $(RN_DOXY_IMG_DIR)/RNLogo.png
endif

# doxygen @INCLUDE to add common package field settings
ifndef RNMAKE_DOXY_AT_INCLUDE
RNMAKE_DOXY_AT_INCLUDE = $(RN_DOXY_STYLE_DIR)/rn_doxy.conf
endif

# doxygen field: HTML_OUTPUT (no overrides)
DOXY_HTML_OUTPUT	= srcdoc

# documentation distrubution paths and subdirectories
DISTDIR_DOC_DOXY			= $(DISTDIR_DOC)/$(DOXY_HTML_OUTPUT)
DISTDIR_DOC_DOXY_IMG	= $(DISTDIR_DOC_DOXY)/images
DISTDIR_DOC_PUB				= $(DISTDIR_DOC)/papers

# logging files
DOXY_OUT_LOG	= $(DISTDIR_TMP)/doxy.out.log
DOXY_ERR_LOG	= $(DISTDIR_TMP)/doxy.err.log

# published papers source directories
SRCDIR_PUB_DOCS				= $(RNMAKE_PKG_ROOT)/docs/published
SRCDIR_PUB_3RD_PARTY	= $(RNMAKE_PKG_ROOT)/docs/3rdparty/published

# pydoc (redundant with Rules.python.mk, any way to combine?)
PYDOC_DIR 					= pydoc
DISTDIR_DOC_PYDOC		= $(DISTDIR_DOC)/$(PYDOC_DIR)
DISTDIR_PYDOC_IMG 	= $(DISTDIR_PYDOC)/images
DISTDIR_PYDOC_HTML 	= $(DISTDIR_PYDOC)/html

# file regex patterns
RE_IMG = .*\.png\|.*\.jpg\|.*\.gif\|.*\.svg\|.*\.tiff
RE_PUB = .*\.pdf\|.*\.ps\|.*\.html\|.*\.tar\|.*\.gz

#$(info DBG: RNMAKE_DOXY_CONF_FILE = $(RNMAKE_DOXY_CONF_FILE))
#$(info DBG: RNMAKE_DOXY_HTML_HEADER = $(RNMAKE_DOXY_HTML_HEADER))
#$(info DBG: RNMAKE_DOXY_HTML_FOOTER = $(RNMAKE_DOXY_HTML_FOOTER))
#$(info DBG: RNMAKE_DOXY_HTML_STYLESHEET = $(RNMAKE_DOXY_HTML_STYLESHEET))
#$(info DBG: RNMAKE_DOXY_IMAGES = $(RNMAKE_DOXY_IMAGES))
#$(info DBG: RNMAKE_DOXY_PROJECT_LOGO = $(RNMAKE_DOXY_PROJECT_LOGO))
#$(info DBG: RNMAKE_DOXY_AT_INCLUDE = $(RNMAKE_DOXY_AT_INCLUDE))

# -------------------------------------------------------------------------
# Target: documents
# Desc:   Make documentation.
#.PHONY: documents
documents: pkg-banner documents-echo docs-clean docs-src-gen docs-pub-gen \
					subdirs-supp-docs docs-final
	$(footer)

.PHONY: documents-echo
documents-echo:
	$(call printGoalWithDesc,$(@),Make all documentation)

docs-clean:
	$(printCurGoal)
	$(RM) $(DISTDIR_DOC_PUB)
	$(RM) $(DISTDIR_DOC_DOXY)

# -------------------------------------------------------------------------
# Target: docs-src-gen
# Desc:   Generate doxygen source documentations.
ifdef RNMAKE_DOXY_ENABLED
docs-src-gen: pkg-banner echo-docs-src-gen
	@test -d $(DISTDIR_DOC_DOXY) || $(MKDIR) $(DISTDIR_DOC_DOXY)
	@test -d $(DISTDIR_DOC_DOXY_IMG) || $(MKDIR) $(DISTDIR_DOC_DOXY_IMG)
	@test -d $(DISTDIR_TMP) || $(MKDIR) $(DISTDIR_TMP)
	@if [ "$(RNMAKE_DOXY_CONF_FILE)" ]; \
	then \
		$(CP) $(RNMAKE_DOXY_HTML_STYLESHEET) $(DISTDIR_DOC_DOXY)/.; \
		$(call copyPat,$(RNMAKE_DOXY_IMAGES),$(DISTDIR_DOC_DOXY_IMG),$(RE_IMG));\
		echo; \
		echo "Making doxygen $(RNMAKE_PKG_ROOT) source documentation"; \
		(cat $(RNMAKE_DOXY_CONF_FILE); \
		 echo "PROJECT_NUMBER=$(RNMAKE_PKG_VERSION_DOTTED)"; \
		 echo "HTML_HEADER=$(RNMAKE_DOXY_HTML_HEADER)"; \
		 echo "HTML_FOOTER=$(RNMAKE_DOXY_HTML_FOOTER)"; \
		 echo "OUTPUT_DIRECTORY=$(DISTDIR_DOC)"; \
		 echo "HTML_OUTPUT=$(DOXY_HTML_OUTPUT)"; \
		 echo "PROJECT_LOGO=$(RNMAKE_DOXY_PROJECT_LOGO)"; \
		 echo "@INCLUDE=$(RNMAKE_DOXY_AT_INCLUDE)"; \
		) | doxygen - >$(DOXY_OUT_LOG) 2>$(DOXY_ERR_LOG); \
		echo "Done (see $(DISTDIR_TMP) for output and error logs)"; \
	fi
	$(footer)
else
docs-src-gen: ;
endif

# This utility script is no longer used after doxygen 1.7. DEPRECATED
#		$(RNMAKE_ROOT)/utils/doxyindex.sh \
#							-t "$(RNMAKE_PKG) v$(RNMAKE_PKG_VERSION_DOTTED)" \
#							-h $(RNMAKE_DOXY_HTML_HEADER) \
#							>$(DISTDIR_DOC)/$(DOC_DOXY_SRCDOC)/index.html; \

# -------------------------------------------------------------------------
# Target: docs-pub-gen
# Desc:  	generate published documentation
docs-pub-gen: pkg-banner echo-docs-pub-gen
	@test -d $(DISTDIR_DOC_PUB) || $(MKDIR) $(DISTDIR_DOC_PUB)
	@if [ -d $(SRCDIR_PUB_DOCS) ]; \
	then \
		$(call copyPat,$(SRCDIR_PUB_DOCS),$(DISTDIR_DOC_PUB),$(RE_PUB)); \
	fi
	@if [ -d $(SRCDIR_PUB_3RD_PARTY) ]; \
	then \
		echo; \
		echo "Copying third-party published documents."; \
		$(call copyPat,$(SRCDIR_PUB_3RD_PARTY),$(DISTDIR_DOC_PUB),$(RE_PUB)); \
	fi
	$(footer)

# -------------------------------------------------------------------------
# Target: docs-final
# Desc:  	finalize documentation
ifeq ($(color),off)
nocolor_opt = --no-color
endif
docs-final: echo-docs-final
	@if [ -f "$(RNMAKE_PKG_HOME_INDEX)" ]; \
	then \
		$(PYTHON) $(RNMAKE_ROOT)/utils/homepagemk.py \
			--rel-files="$(addsuffix ;,$(REL_FILES))" \
			--doxy-index="$(DOXY_HTML_OUTPUT)/index.html" \
			$(nocolor_opt) \
			--pydoc-index="$(PYDOC_DIR)/index.html" \
			--pub-dir=papers \
			--images-path="$(DOXY_HTML_OUTPUT)/images:$(PYDOC_DIR)/images" \
			--verbose \
			author="$(RNMAKE_PKG_AUTHORS)" \
			pkg_name="$(RNMAKE_PKG)" \
			pkg_ver="$(RNMAKE_PKG_VERSION_DOTTED)" \
			pkg_logo="$(RNMAKE_PKG_LOGO)" \
			org="$(RNMAKE_ORG)" \
			org_fq="$(RNMAKE_ORG_FQ)" \
			org_abbrev="$(RNMAKE_ORG_ABBREV)" \
			org_logo="$(RNMAKE_ORG_LOGO)" \
			org_url="$(RNMAKE_ORG_URL)" \
			favicon="$(RNMAKE_ORG_FAVICON)" \
			$(RNMAKE_PKG_HOME_INDEX) $(DISTDIR_DOC); \
	fi
	$(footer)


ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
