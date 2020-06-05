################################################################################
#
# version_h.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Auto-generate the version.h include file for the package.

\par Usage:
make RNMAKE_PKG_ROOT=\<dir\> version_h=\<file\> pkg_mk=\<file\> autogen

\pkgsynopsis RN Make System
\pkgfile{version_h.mk}
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

export _VERSION_H_MK = 1

include $(pkg_mk)

timestamp := $(shell date "+%Y.%m.%d %T")

# $(call genDefine,brief,macro,value)
# 	Generatate define.
define genDefine =
@echo '/*! $(1) */'"\n"'#define $(2) $(3)'"\n" >> $(version_h)
endef

.PHONY: autogen
autogen: 	echo-autogen \
					gen-top-comment \
					gen-begin-ifndef \
					gen-defines \
					gen-end-ifndef \

.PHONY: echo-autogen
echo-autogen:
	@echo 'Auto-generating $(version_h)'
	
.PHONY: gen-top-comment
gen-top-comment:
	@echo "\
/*! \\\\file\n\
 *\n\
 * \\\\brief Package version information.\n\
 *\n\
 * \\\\warning Auto-generated by Rules.mk on $(timestamp)\n\
 *\n\
 * \\\\pkgfile{$(notdir $(version_h))}\n\
 */\n" >> $(version_h)

.PHONY: gen-begin-ifndef
gen-begin-ifndef:
	@echo "\
#ifndef _VERSION_H\n\
#define _VERSION_H\n" >> $(version_h)

.PHONY: gen-includes
gen-includes:
	@echo "#include \"rnr/pkg.h\"\n" >> $(version_h)

.PHONY: gen-defines
gen-defines:
	$(call genDefine,package name,PKG_NAME,"$(RNMAKE_PKG)")
	$(call genDefine,package dotted version,PKG_VERSION,"$(RNMAKE_PKG_VERSION_DOTTED)")
	$(call genDefine,package build date,PKG_TIMESTAMP,"$(timestamp)")
	$(call genDefine,package extended creation date,PKG_DATE,"$(RNMAKE_PKG_VERSION_DATE)")
	$(call genDefine,package full name,PKG_FULL_NAME,"$(RNMAKE_PKG_FULL_NAME)")
	$(call genDefine,package author(s),PKG_AUTHORS,"$(RNMAKE_PKG_AUTHORS)")
	$(call genDefine,package owner(s),PKG_OWNERS,"$(RNMAKE_PKG_OWNERS)")
	$(call genDefine,package legal disclaimer,PKG_DISCLAIMER,"$(RNMAKE_PKG_DISCLAIMER)")

.PHONY: gen-end-ifndef
gen-end-ifndef:
	@echo "#endif // _VERSION_H\n" >> $(version_h)

ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
