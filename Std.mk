################################################################################
#
# Std.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief A collection of make defined functions, canned sequences, variables, and
targets that any RN Make System makefile may use.

This makefile is mostly independent of RNMAKE variables and, hence, can usually
be included almost anywhere in the including makefile.

Optionally includes Colors.mk

\pkgsynopsis RN Make System
\pkgfile{Std.mk}
\pkgauthor{Robin Knight,robin.knight@roadnarrows.com}
\pkgcopyright{2018,RoadNarrows LLC,http://www.roadnarrows.com}

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

export _STD_MK = 1

# include colars
ifndef _COLORS_MK
-include $(RNMAKE_ROOT)/Colors.mk
endif

#------------------------------------------------------------------------------
# Inter-makefile helper functions and canned sequences

# $(call fatal,emsg)
# 	Print fatal message and exit.
# 	Note: The built-in 'error' function takes precedence and does not support
# 				escape sequences.
define fatal = 
$(error $(1))
endef

# $(call printError,emsg)
# 	Print error message.
define printError = 
@printf "$(color_error)Error: $(1)$(color_post)\n"
endef

# $(call printWarning,wmsg)
# 	Print warning message.
# 	Note: The built-in 'warning' function takes precedence and does not support
# 				escape sequences. Line numbers are printed. 
define printWarning = 
@printf "$(color_warn)Warning: $(1)$(color_post)\n"
endef

# $(call printInfo,msg)
# 	Print information message.
# 	Note: The built-in 'info' function takes precedence and does not support
# 				escape sequences. No line numbers are printed. 
define printInfo = 
@printf "$(color_info)$(1)$(color_post)\n";
endef

# $(call findGoals,goalpattern...)
#   Find goal patterns in command-line goal list. Returns whitespace separated
# 	list of matched goals or empty string.
define findGoals =
$(filter $(1),$(GOAL_LIST))
endef

# $(call includeIfGoals,goalpattern...,makefile)
# 	Conditionally include makefile if one of the goal patterns matches the
# 	command-line goal list.
define includeIfGoals =
$(if $(call findGoals,$(1)),$(eval include $(2)))
endef

# $(call neq,op1,op2)
# $(call eq,op1,op2)
# 	Comparison operators. GNU Make has no comparison functions. Why??? Fake it.
# 	Returns non-empty string if true.
neq = $(filter-out $(1),$(2))
eq  = $(if $(call neq,$(1),$(2)),,1)

# $(call isFile,file)
# $(call isDir,file)
# 	Tests if file exists and specifies a regular file (directory).
# 	Returns non-empty string on true, empty string on false.
isFile = $(shell  if [ -f $(1) ]; then echo 1; fi)
isDir  = $(shell  if [ -d $(1) ]; then echo 1; fi)

# $(call mkadir,dir)
# 	Conditionally make a directory.
mkadir = test -d "$(1)" || $(MKDIR) "$(1)"

# $(call isAbsPath,path)
# 	Test if path is absolute (starts with '/') rather than relative.
isAbsPath = $(if $(filter /%,$(RNMAKE_INSTALL_PREFIX)),1)

# $(call mkAbsPath,path,root)
# 	If path is absolute, return path. Otherwise return root/path.
mkAbsPath = $(abspath $(if $(call isAbsPath,$(1)),$(1),$(2)/$(1)))

# $(call findReqFile,file,errmsg)
# 	Find the required file. On failure calls error with appended optional
# 	errmsg. Returns absolute filename.
define findReqFile =
$(if $(realpath $(1)),$(strip $(realpath $(1))),\
$(error $(1): No such file$(if $(2),: $(strip $(2)),)))
endef

# $(call makeSearchPath,dir...)
# 	Make search path path[:path...].
define makeSearchPath =
$(shell 
			p=""; \
			for d in $(1); \
			do \
				if [ -z "$${p}" ];
				then \
					p="$${d}"; \
				else \
  				p="$${p}:$${d}"; \
				fi; \
			done; \
			echo "$${p}")
endef

# $(call copyTrees,src...,dstdir)
# 
# Recursively copy directory trees and source files to dstdir.
# 
# If dstdir does not exist, it is automatically created.
#
define copyTrees =
	@test -d $(2) || $(MKDIR) $(2); \
	for src in $(1); \
	do \
		if [ -d $${src} ]; \
		then \
			printf "  $(color_info)$${src}$(color_post)\n"; \
		fi; \
		$(CP_R) $(CP_OPT_UPDATE) $(CP_OPT_VERBOSE) $${src} $(2); \
	done
endef

# $(call copyPat,srcdir,dstdir,pat)
#
# Template to recursively copy files from the source directory that match
# the regex pattern to the destination directory. Each file is copied iff the
# destination file does not exists or if the source is newer. Destination
# [sub]directories are created as needed.
#
# srcdir	Source directory.
# dstdir	Destination directory.
# pat			Regex pattern. Default: .* (all files)
#
# Example:
# 	my/pics/
# 		cutekitty.jpg
# 		dogs/
# 			badboy.png
# 			fido.jpg
# 		hippos/
# 			iwantone.log
# 		list.txt
#
# 	$(call copyPat,my/pics,/archive,.*\.png\|.*\.jpg\|.*\.gif\|.*\.svg)
#
# 	/archive/
# 		cutekitty.jpg
# 		dogs/
# 			badboy.png
# 			fido.jpg
define copyPat =
	if [ "$(1)" -a "$(2)" -a "$(3)" ]; \
	then \
		printf "  $(color_info)$(1)$(color_post)\n"; \
		$(FIND) $(1) -type f -regex '$(3)' | \
		while read src; \
		do \
			f=$$(basename $${src}); \
			d=$$(dirname $${src}); \
			sd=$${d##$(1)}; \
			if [ "$${sd}" = "" -o "$${sd}" = "/" -o "$${sd}" = "." ]; \
			then \
				dst=$(2)/$${f};\
			else \
				sd=$${sd##/}; \
				dst=$(2)/$${sd}/$${f};\
  			test -d $(2)/$${sd} || $(MKDIR) $(2)/$${sd}; \
			fi; \
			$(CP) $(CP_OPT_UPDATE) $(CP_OPT_VERBOSE) $${src} $${dst}; \
		done; \
	fi
endef

# $(call copyPatForce,src,dst,pat)
#
# Same as copyPat except that matched files are always copied.
#
# srcdir	Source directory.
# dstdir	Destination directory.
# pat			Regex pattern.
define copyPatForce =
	if [ "$(1)" -a "$(2)" -a "$(3)" ]; \
	then \
		printf "  $(color_info)$(1)$(color_post)\n"; \
		$(FIND) $(1) -type f -regex '$(3)' | \
		while read src; \
		do \
			f=$$(basename $${src}); \
			d=$$(dirname $${src}); \
			sd=$${d##$(1)}; \
			if [ "$${sd}" = "" -o "$${sd}" = "/" -o "$${sd}" = "." ]; \
			then \
				dst=$(2)/$${f};\
			else \
				sd=$${sd##/}; \
				dst=$(2)/$${sd}/$${f};\
  			test -d $(2)/$${sd} || $(MKDIR) $(2)/$${sd}; \
			fi; \
			$(CP) $(CP_OPT_VERBOSE) $${src} $${dst}; \
		done; \
	fi
endef

# $(call printPkgBanner,pkgname,arch,goallist)
# 	Print the package banner.
# 		pkgname 	= RNMAKE_PKG_FULL_NAME
# 		arch			= RNMAKE_ARCH
# 		goallist	= MAKECMDGOALS
define printPkgBanner =
	@{\
	printf "$(color_pkg_banner)$(boldline)\n";\
	printf "Package:       $(1)\n";\
	printf "Package Root:  $(RNMAKE_PKG_ROOT)\n";\
	printf "Architecture:  $(2)\n";\
	printf "Directory:     $(CURDIR)\n";\
	printf "Goal(s):       $(3)\n";\
	printf "Start:         `date`\n";\
	printf "$(boldline)$(color_end)\n";\
	}
endef

# $(call printDirBanner,dir,goal)
# 	Print directory banner. The dir parameter is relative path from 
# 	$(RNMAKE_PKG_ROOT). If the dir parameter is empty, the basename of
# 	$(RNMAKE_PKG_ROOT) is used.
define printDirBanner =
	@if [ "$(1)" = "" ]; then \
		subdirname=$(notdir $(RNMAKE_PKG_ROOT));\
	elif [ "$(1)" = "." ]; then \
		subdirname="$(patsubst $(dir $(RNMAKE_PKG_ROOT))%,%,$(CURDIR))";\
	else \
		subdirname="$(patsubst $(dir $(RNMAKE_PKG_ROOT))%,%,$(CURDIR)/$(1))";\
	fi; \
	goal="$(call deecho,$(2))";\
	printf "\n";\
	printf "$(color_dir_banner)$(normline)\n";\
	printf "Directory: $$subdirname\n";\
	printf "Goal:      $$goal\n";\
	printf "$(normline)$(color_end)\n";
endef

# $(call printGoal,goal)
# 	Print goal in standard format and color. Any echo substring in goal will be
# 	stripped.
define printGoal =
@printf "\n     $(color_tgt_file)$(call deecho,$(1))$(color_end)\n"
endef

# $(call deecho,str)
# 	Remove any echo- and -echo substrings from str.
define deecho
$(strip $(subst -echo,,$(subst echo-,,$(1))))
endef

# $(call printGoalWithDesc,goal,desc)
# 	Print goal with optional description.
define printGoalWithDesc =
$(call printGoal,$(1));
$(if $(2),@printf "$(strip $(2))\n",)
endef

# $(printCurGoal)
# 	Print goal using the current target $(@).
printCurGoal = $(call printGoal,$(@))

# $(call printFooter,curgoal,lastgoal)
# 	Conditionally print footer. If the goal is the last command-line goal and
# 	the make level is 0 (top), then the footer is printed.
define printFooter =
	@if [ "$(MAKELEVEL)" = "0" -a "$(1)" = "$(2)" ]; then \
	printf "\n";\
	printf "$(color_pkg_banner)              ###\n";\
	printf "Finished: `date`\n";\
	printf "              ###$(color_end)\n";\
	fi
endef

eqline := \
================================================================================
dotline := \
................................................................................
tildeline := \
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
underline := \
________________________________________________________________________________

boldline := $(eqline)
normline := $(tildeline)

ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
