################################################################################
#
# Rules.test.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Provides "test" targets.

This file is automatically included by \ref Rules.mk when one or more of the
test make goals are specified.

\pkgsynopsis
RN Make System

\pkgfile{Rules.test.mk}

\pkgauthor{Daniel Packard,daniel@roadnarrows.com}
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

export _RULES_TEST_MK = 1

RNMAKE_TEST_ENABLED = y

GOALS_WITH_SUBDIRS += run-test

# Add test targets to local programs
RNMAKE_LOC_PGMS += $(RNMAKE_TEST_PGMS)

GOALS_WITH_SUBDIRS += test

# colors
color_test = $(color_pre)$(color_light_blue)

# Make specific test programs
.PHONY: 	test
test: pkgbanner all subdirs-test
	$(footer)

# Run test programs
.PHONY: run-test
run-test: pkgbanner echo-run-test do-test subdirs-run-test
	$(footer)

.PHONY: echo-run-test
echo-run-test:
	$(call printEchoTgtGoalDesc,Run all tests)

.PHONY: do-test
do-test:
	@for f in $(RNMAKE_TEST_PGMS); \
		do \
			printf "\n$(color_test)         $$f$(color_end)\n"; \
			if [ -x ./$(LOCDIR_BIN)/$$f ]; \
			then \
			  ./$(LOCDIR_BIN)/$$f; \
			else \
				printf "$(color_error)Program $$f does not exist. Did you 'make test' first?$(color_end)\n\n"; \
				break; \
			fi; \
	 done;
	$(footer)


ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
