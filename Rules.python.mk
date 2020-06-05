################################################################################
#
# Rules.python.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Special rules file to make python modules using standard setup.py
python file.

Include this file in each appropriate local make file (usually near the bottom).

\par Key RNMAKE Variables:
	\li RNMAKE_PYTHON_ENABLED	- python is [not] enabled for this architecture.
	\li RNMAKE_PYTHON_PKG 		- python package directory
	                            (default: setup.py --name)

\pkgsynopsis
RN Make System

\pkgfile{Rules.python.mk}

\pkgauthor{Robin Knight,robin.knight@roadnarrows.com}

\pkgcopyright{2010-2018,RoadNarrows LLC,http://www.roadnarrows.com}

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

export _RULES_PYTHON_MK = 1

ifdef RNMAKE_PYTHON_ENABLED

# Must be defined in including makefile.
ifndef RNMAKE_PYTHON_PKG
  $(error 'RNMAKE_PYTHON_PKG': Not defined in including Makefile)
endif

# $(call pythonVer)
# 	Retreive python3's major.minor version string.
define pythonVer =
$(shell v=$$($(PYTHON) --version); v=$${v#[Pp]ython* }; echo $${v%.[0-9]*})
endef

PYTHON_VERSION = $(call pythonVer)
PYTHON_SITE_PKGS = python$(PYTHON_VERSION)/site-packages

# see PEP 425 and PEP 3149
SETUP_BUILD_ROOT		= build
SETUP_DIST_ROOT			= dist
#SETUP_PKG_VERSION 	= $(shell $(PYTHON) setup.py --version)
SETUP_PKG_VERSION		=	$(RNMAKE_PKG_VERSION_DOTTED)
SETUP_PYTHON_TAG		= py3
SETUP_ABI_TAG		    = none
SETUP_PLATFORM_TAG	= linux_$(RNMAKE_ARCH)
SETUP_BUILD_DIR			= $(SETUP_BUILD_ROOT)/build.$(RNMAKE_ARCH)
SETUP_DIST_DIR			= $(SETUP_DIST_ROOT)/dist.$(RNMAKE_ARCH)
SETUP_ZIPPED_WHEEL	= $(RNMAKE_PYTHON_PKG)-$(SETUP_PKG_VERSION)-$(SETUP_PYTHON_TAG)-$(SETUP_ABI_TAG)-$(SETUP_PLATFORM_TAG).whl
SETUP_DIST_TARBALL 	= $(RNMAKE_PYTHON_PKG)-$(SETUP_PKG_VERSION).tar.gz


# find the most recently modified file in the python package
PKG_NEWEST_FILE = $(shell $(FIND) $(RNMAKE_PYTHON_PKG) -type f \
													| $(GREP) -v __pycache__ \
													| $(XARGS) $(LS) -1tr \
													| $(TAIL) -n 1)

PYDOC_DIR	= pydoc

DISTDIR_PYTHON_PKGS = $(DISTDIR_LIB)/$(PYTHON_SITE_PKGS)
DISTDIR_PYDOC 			= $(DISTDIR_DOC)/$(PYDOC_DIR)
DISTDIR_PYDOC_IMG 	= $(DISTDIR_PYDOC)/images
DISTDIR_PYDOC_HTML 	= $(DISTDIR_PYDOC)/html

# -------------------------------------------------------------------------
# Target:	python-all
#
# Use python's standard setuptools to build and install python modules. The 
# "build - install" sequence is equivalent to the RNMAKE "all" target with
# the "install" installing into the package dist/dist.<arch> directory.
python-all: echo-python-all setup.py python-dist-wheel

.PHONY: python-build
python-build: echo-python-build
	$(PYTHON) setup.py build --build-base=$(SETUP_BUILD_DIR)
	$(PYTHON) setup.py egg_info

.PHONY: python-dist-src
python-dist-src: ;

.PHONY: python-dist-wheel
python-dist-wheel: $(SETUP_DIST_DIR)/$(SETUP_ZIPPED_WHEEL)

$(SETUP_DIST_DIR)/%.whl: $(PKG_NEWEST_FILE)
	$(call printGoal,$(@))
	$(PYTHON) setup.py bdist_wheel --bdist-dir=$(SETUP_BUILD_DIR) \
		--dist-dir=$(SETUP_DIST_DIR) --plat-name=$(SETUP_PLATFORM_TAG)
	@test -d "$(DISTDIR_PYTHON_PKGS)" || $(MKDIR) $(DISTDIR_PYTHON_PKGS)
	$(UNZIP) -q $(@) -d $(DISTDIR_LIB)/python$(PYTHON_VERSION)/site-packages
	@$(MV) $(SETUP_BUILD_ROOT)/lib $(SETUP_BUILD_DIR)

.PHONY: python-dist-egg
python-dist-egg: ;

# -------------------------------------------------------------------------
# Target: python-doc
# Desc:   Generate pydoc source documentations.
.PHONY: python-doc
ifdef RNMAKE_PYDOC_ENABLED
ifeq ($(color),off)
nocolor_opt = --no-color
endif
python-doc:
	$(call printGoalWithDesc,$(@),\
		Making $(RNMAKE_PYTHON_PKG) python documentation)
	@test -d "$(DISTDIR_PYDOC)" || $(MKDIR) $(DISTDIR_PYDOC)
	@test -d "$(DISTDIR_PYDOC_IMG)" || $(MKDIR) $(DISTDIR_PYDOC_IMG)
	@test -d "$(DISTDIR_PYDOC_HTML)" || $(MKDIR) $(DISTDIR_PYDOC_HTML)
	@$(PYTHON) $(RNMAKE_ROOT)/utils/pydocmk.py \
		--template="$(RNMAKE_PYDOC_INDEX)" \
		--images-src-dir=$(RNMAKE_PKG_ROOT)/docs/images \
		$(nocolor_opt) \
		--verbose \
		org="$(RNMAKE_ORG)" \
		org_fq="$(RNMAKE_ORG_FQ)" \
		org_abbrev="$(RNMAKE_ORG_ABBREV)" \
		org_logo="$(RNMAKE_ORG_LOGO)" \
		favicon="$(RNMAKE_ORG_FAVICON)" \
		$(DISTDIR_PYDOC) ./setup.py
else
python-doc: ;
endif

# -------------------------------------------------------------------------
# Target: python-clean
# Desc:   Clean intermediaries
.PHONY: python-clean
python-clean:
	$(call printGoalWithDesc,$(@),Cleaning $(RNMAKE_PYTHON_PKG) python module)
	@$(FIND) $(RNMAKE_PYTHON_PKG) -type d -name '__pycache__' | \
		while read d; \
		do \
			printf "$(RM) $$d\n"; \
			$(RM) $$d; \
		done
	$(RM) __pycache__
	$(RM) $(SETUP_BUILD_ROOT)/lib
	$(RM) setup.py

# -------------------------------------------------------------------------
# Target: python-distclean
# Desc:   Clean distribution
.PHONY: python-distclean
python-distclean:
	$(call printGoalWithDesc,$(@),Clobbering $(RNMAKE_PYTHON_PKG) python module)
	$(RM) $(SETUP_BUILD_ROOT)/bdist.* $(SETUP_BUILD_DIR)
	$(RM) $(SETUP_DIST_ROOT)/*.whl $(SETUP_DIST_DIR)
	$(RM) $(RNMAKE_PYTHON_PKG).egg-info

setup.py: $(RNMAKE_PKG_ROOT)/pkgcfg/package.mk
	@$(RNMAKE_ROOT)/tools/rnparse_template \
		--verbose \
		pkg_name="$(RNMAKE_PYTHON_PKG)" \
		pkg_ver="$(RNMAKE_PKG_VERSION_DOTTED)" \
		pkg_author="$(RNMAKE_PKG_AUTHORS)" \
		pkg_email="$(RNMAKE_PKG_EMAIL)" \
		pkg_desc="$(RNMAKE_PKG_DESC)" \
		pkg_license="$(RNMAKE_PKG_LICENSE)" \
		pkg_kw="$(RNMAKE_PKG_KEYWORDS)" \
		pkg_url="$(RNMAKE_PKG_URL)" \
		org_url="$(RNMAKE_ORG_URL)" \
		setup.py.tpl setup.py

else

python-all python-doc python-clean python-distclean:
	@printf "python not enabled - ignoring\n"

endif

ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
