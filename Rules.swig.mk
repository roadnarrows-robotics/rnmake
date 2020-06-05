################################################################################
#
# Rules.swig.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Special rules file for swigging C into python.

Include this file in each appropriate local make file (usually near the bottom).

\par Key RNMAKE Variables:
	\li SWIG_FILES 				- list of swig *.i interface files.
	\li SWIG_EXTMOD_DIR		- output *.py and shared libraries directory.
	\li SWIG_EXTMOD_LIBS	- list of -l<lib> libraries to link in.

\pkgsynopsis
RN Make System

\pkgfile{Rules.swig.mk}

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

export _RULES_SWIG_MK = 1

ifeq ($(strip $(RNMAKE_SWIG_ENABLED)),y)

WRAPDIR = wrap/wrap.$(RNMAKE_ARCH)

mkwrapdir = @test -d "$(WRAPDIR)" || $(MKDIR) "$(WRAPDIR)"

SWIG_BASES      = $(basename $(SWIG_FILES))
SWIG_FILES_C    = $(addsuffix .c,$(SWIG_BASES))
SWIG_FILES_O    = $(addprefix $(OBJDIR)/,$(subst .c,.o_,$(SWIG_FILES_C)))
SWIG_WRAPPED_C  = $(addprefix $(WRAPDIR)/,$(SWIG_FILES_C))
SWIG_FILES_PY   = $(addprefix $(SWIG_EXTMOD_DIR)/,\
                              $(addsuffix .py,$(SWIG_BASES)))
SWIG_EXTMODS    = $(addprefix $(SWIG_EXTMOD_DIR)/_,\
                              $(addsuffix $(SHLIB_SUFFIX),$(SWIG_BASES)))

# Get python3 version stripped of revision number.
PYTHON_VER = $(shell $(PYTHON) --version 2>&1 | sed -e 's/Python\s\+\([0-9]\+\.[0-9]\+\).*$$/\1/')

ifeq "$(RNMAKE_ARCH)" "cygwin"
SWIG_PYLIB = -lpython$(PYTHON_VER).dll
else
SWIG_PYLIB = -lpython$(PYTHON_VER)m
endif

ifndef "$(SWIG_INCLUDES)"
SWIG_INCLUDES = -I/usr/include/python$(PYTHON_VER)
endif

SWIG_LIBS = $(SWIG_EXTMOD_LIBS) $(SWIG_PYLIB)
SWIG_DONE = $(RNMAKE_ARCH).done

# Target: swig-all (default)
.PHONY: swig-all
swig-all: echo-swig-all swig-pre swig-mods
	@$(TOUCH) $(SWIG_DONE)

.PHONY: echo-swig-all
echo-swig-all:
	$(call printGoalWithDesc,$(@),Creating python wrappers from C/C++ source)

# Target: swig-pre
#   If targets were made for another architecture, then clean up so that targets
#   will be remade for the target architecture. The file done.<arch> determines
#   the last made target architecture.
.PHONY: swig-pre
swig-pre:
	@if [ ! -f $(SWIG_DONE) ]; \
	then \
		if [ -f *.done ]; \
		then \
			printf "Cleaning previous target: $(basename $(wildcard *.done)).\n"; \
			$(RM) *.done; \
		fi; \
		$(RM) $(OBJDIR); \
		$(RM) $(SWIG_WRAPDIR); \
		$(RM) $(SWIG_FILES_PY); \
		$(RM) $(SWIG_EXTMODS); \
	fi

# Target: swig-mods
# Make all swig modules
swig-mods: $(SWIG_EXTMODS)

.PHONY: swig-doc
swig-doc:
	$(call printGoalWithDesc,$(@),Making swigged documentation)

# Target:	swig-clean
.PHONY: swig-clean
swig-clean:
	$(call printGoalWithDesc,$(@),Cleaning python swigged python modules)
	$(RM) $(WRAPDIR)
	$(RM) $(SWIG_FILES_PY)
	$(RM) $(SWIG_EXTMODS)
	$(RM) *.done

.PHONY: swig-distclean
swig-distclean:
	$(call printGoalWithDesc,$(@),Clobbering python swigged python modules)

# Target: done
#   Make determines dependency sequence only for the first file (*.i) and the
#   end file. Itermediates are not factored in. But rnmake supports
#   cross-compiling, so the <name>.<arch>.done file is used as an artificial
#   end file to force compliling.
%.$(RNMAKE_ARCH).done: $(SWIG_EXTMOD_DIR)/_%$(SHLIB_SUFFIX)
	$(RM) *.done
	$(TOUCH) $(@)

# Swig Architecture-Specific Shared Library Rule:
$(SWIG_EXTMOD_DIR)/_%$(SHLIB_SUFFIX) : $(OBJDIR)/%.o_
	@printf "\n"
	@printf "$(color_tgt_lib)     $(@)$(color_end)\n"
	$(SHLIB_LD) $(LDFLAGS) $(SWIG_LDFLAGS) $(LD_LIBPATHS) $(<) $(SWIG_LIBS) \
		-o $(@)

# Swig C Rule: $(WRAPDIR)/<name>.c -> $(OBJDIR)/<name>.o_
# Note: To override the rnmake default %.o pattern rule, arbitrarily set the
# 			object file suffix to 'o_'. A hack. But it works.
$(OBJDIR)/%.o_ : $(WRAPDIR)/%.c
	@printf "\n"
	@printf "$(color_tgt_file)     $(<)$(color_end)\n"
	$(mkobjdir)
	$(CC) $(CFLAGS) $(SWIG_CFLAGS) $(CPPFLAGS) $(INCLUDES) $(SWIG_INCLUDES) \
		-o $(@) -c $(<)

# Swig I Rule: <name>.i -> $(WRAPDIR)/<name>.c, <outdir>/<name>.py
$(WRAPDIR)/%.c : %.i
	@printf "\n"
	@printf "$(color_tgt_file)     $(<)$(color_end)\n"
	$(mkwrapdir)
	$(SWIG) -python $(INCLUDES) $(SWIG_INCLUDES) -v -outdir $(SWIG_EXTMOD_DIR) \
		-o $(@) $(<)

# don't autodelete intermediate files
.SECONDARY: $(SWIG_WRAPPED_C) $(SWIG_FILES_O) $(SWIG_EXTMODS)

# swig not enabled
else

swig-all swig-doc swig-clean swig-distclean:
	@printf "swig not enabled - ignoring\n"

endif

ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
