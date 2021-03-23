################################################################################
#
# Cmds.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Host commands independent of target architecture.

\pkgsynopsis
RN Make System

\pkgfile{Cmds.mk}

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

export _CMDS_MK = 1

# Force make to use /bin/bash
export SHELL = /bin/sh

# Common file commands and options
BASENAME				= basename
CHMOD         	= chmod
CP							= cp -fp
CP_R						= $(CP) -r
CP_OPT_UPDATE		= -u
CP_OPT_VERBOSE	= -v
DIRNAME					= dirname
FILE						= file
FIND						= find
FOLD						= fold -s
GREP						= grep
HEAD						= head
INSTALL_DIR   	= install -d -p -m 775
INSTALL_EXE   	= install -p -m 775
INSTALL       	= install -p -m 664
LS							= ls
MKDIR         	= mkdir -p -m 775
MV							= mv
RM							= rm -fr
RMFILE					= rm -f
SED							= sed -r
SYMLINK					= ln -s
TAIL						= tail
ifeq "$(ARCH)" "osx"
TAR							= tar -c -z -f
TAR_VERBOSE			= tar -c -z -v -f
else
TAR							= tar --create --gzip --atime-preserve --file
TAR_VERBOSE			= tar --create --gzip --atime-preserve --verbose --file
endif
TOUCH						= touch
UNLINK					= unlink
UNZIP						= unzip -u -o
XARGS						= xargs

# Interpreters
PYTHON       ?= /usr/bin/python3
PERL          = /usr/bin/perl

# LEX and YACC
LEX           = flex
YACC          = bison -y


ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
