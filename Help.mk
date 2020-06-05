################################################################################
#
# Help.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Prints help message(s) for Rules.mk.

\pkgsynopsis
RN Make System

\pkgfile{Help.mk}

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

export _HELP_MK = 1

$(info rnmake - RoadNarrows Make System Help)

ARCH_LIST = $(subst $(RNMAKE_ROOT)/Arch/Arch.,,\
						$(basename $(wildcard $(RNMAKE_ROOT)/Arch/Arch.*.mk)))

SUBHELPS = help-usage help-env help-arch help-targets help-install \
						help-tarballs help-dpkg help-other help-help

help: MAJOR_GOAL = help
.PHONY:   help
help: $(SUBHELPS)

help-usage:
	$(printCurGoal)
	@echo "\
Usage: make [RNMAKEVARS] [MAKEOPTS] [MAKEARGS] [TARGET [TARGET...]]\n\
       make help"
	@echo
	@echo "\
Make rnmake defined target goals TARGET... in command-line order"
	@echo
	@echo "\
Specific rnmake variables:\n\
  arch=TAG       Specify rnmake Arch/Arch.TAG.mk architecture make file.\n\
                 Overrides environment variable RNMAKE_ARCH_DFT.\n\
                   fallback default: x86_64\n\
  color=SCHEME   Set color scheme. One of:\n\
                   rnmake(default) neon brazil whites off(no color)\n\
  xprefix=PATH   Cross-install directory path prefix. Overrides environment\n\
                 variable RNMAKE_INSTALL_XPREFIX.\n\
                   fallback default: \$$(HOME)/xinstall\n\
  prefix=PATH    Install directory path prefix. Overrides environment\n\
                 variable RNMAKE_INSTALL_PREFIX.\n\
                   fallback default: \$$(RNMAKE_INSTALL_XPREFIX)"
	@echo
	@echo "\
GNU make options and arguments:\n\
  See MAKE(1)."
  
help-env:
	$(call printGoal,$(@))
	@echo "\
Environment Variables\n\
RNMAKE_ARCH_DFT          Default rnmake architecture tag.\n\
RNMAKE_INSTALL_XPREFIX   Cross-install directory path.\n\
RNMAKE_INSTALL_PREFIX    Install directory path."

help-arch:
	$(printCurGoal)
	@echo "Supported Architecture Tags (see $(RNMAKE_ROOT)/Arch)"
	@echo $(sort $(ARCH_LIST)) | $(FOLD)

help-targets:
	$(printCurGoal)
	@echo "\
Major Build Targets\n\
all        - (default) makes the distribution [sub]package(s)\n\
clean      - deletes generated intermediate files\n\
clobber    - distclean synonym\n\
dpkgs      - makes all debian packages for an architecture\n\
deps       - makes source dependencies\n\
distclean  - cleans plus deletes distribution and local made files\n\
documents  - makes documentation\n\
install    - installs the distribution\n\
libs       - makes all libraries in current directory\n\
pgms       - makes all programs in current directory\n\
subdirs    - makes all subdirectories of current directory\n\
tarballs   - makes package binary, source, and documentation tarballs"

help-install:
	$(printCurGoal)
	@echo "\
Install Specific Targets\n\
install           - installs package distribution files\n\
install-bin       - installs package distribution executables\n\
install-lib       - installs package distribution libraries\n\
install-includes  - installs package distribution API headers\n\
install-docs      - installs package distribution documentation\n\
install-share     - installs package distribution system share files\n\
install-etc       - installs package distribution configuration files"

help-tarballs:
	$(printCurGoal)
	@echo "\
Tarball Specific Targets\n\
tarballs     - makes package binary, source, and documentation tarballs\n\
tarball-bin  - makes package executables tarball\n\
tarball-doc  - makes documentation tarball\n\
tarball-src  - makes source tarball"

help-dpkg:
	$(printCurGoal)
	@echo "\
Debian Package Specific Targets\n\
dpkgs     - makes all debian packages for an architecture\n\
dpkg-dev  - makes debian development package\n\
dpkg-doc  - makes debian documentation package\n\
dpkg-src  - makes debian source package"

help-other:
	$(printCurGoal)
	@echo "\
Focused Targets\n\
LIB         - makes library LIB in current directory\n\
PGM         - makes program PGM in current directory\n\
SRC.e       - makes post CPP processed source from SRC.{c|cxx|cpp}\n\
SRC.o       - makes object from SRC.{c|cxx|cpp}\n\
SUBDIR.all  - makes subdirectory SUBDIR of current directory"

help-help:
	$(printCurGoal)
	@echo "Supported Sub-Helps Targets"
	@echo "$(sort $(SUBHELPS))" | $(FOLD)

ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
