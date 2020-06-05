################################################################################
#
# Colors.mk
#
ifdef RNMAKE_DOXY
/*! 
\file 

\brief Color schemes.

\pkgsynopsis
RN Make System

\pkgfile{Colors.mk}

\pkgauthor{Robin Knight,robin.knight@roadnarrows.com}

\pkgcopyright{2012-2018,RoadNarrows LLC,http://www.roadnarrows.com}

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

export _COLORS_MK = 1

color ?= rnmake

ifneq "$(color)" "off"

	export color_pre   					= \033[
	export color_post  					= \033[0m
	export color_black   				= 0;30m
	export color_red   					= 0;31m
	export color_green   				= 0;32m
	export color_yellow					= 0;33m
	export color_blue   				= 0;34m
	export color_magenta   			= 0;35m
	export color_cyan   				= 0;36m
	export color_white   				= 0;37m
	export color_gray   			  = 1;30m
	export color_light_red   		= 1;31m
	export color_light_green   	= 1;32m
	export color_light_yellow		= 1;33m
	export color_light_blue   	= 1;34m
	export color_light_magenta	= 1;35m
	export color_light_cyan   	= 1;36m
	export color_bright_white  	= 1;37m

	# fixed colors
	export color_error	= $(color_pre)$(color_red)
	export color_warn		= $(color_pre)$(color_yellow)
	export color_info		= $(color_pre)$(color_blue)

	# default rnmake color scheme
	ifeq "$(color)" "rnmake"
		color_end 				= $(color_post)
		color_pkg_banner 	= $(color_pre)$(color_light_blue)
		color_dir_banner 	= $(color_pre)$(color_yellow)
		color_tgt_file 		= $(color_pre)$(color_green)
		color_tgt_lib 		= $(color_pre)$(color_cyan)
		color_tgt_pgm 		= $(color_pre)$(color_light_magenta)

	# neon color scheme
	else ifeq "$(color)" "neon"
		color_end 				= $(color_post)
		color_pkg_banner 	= $(color_pre)$(color_light_red)
		color_dir_banner 	= $(color_pre)$(color_light_magenta)
		color_tgt_file 		= $(color_pre)$(color_light_cyan)
		color_tgt_lib 		= $(color_pre)$(color_light_yellow)
		color_tgt_pgm 		= $(color_pre)$(color_light_yellow)

	# brazil color scheme
	else ifeq "$(color)" "brazil"
		color_end 				= $(color_post)
		color_pkg_banner 	= $(color_pre)$(color_green)
		color_dir_banner 	= $(color_pre)$(color_green)
		color_tgt_file 		= $(color_pre)$(color_light_yellow)
		color_tgt_lib 		= $(color_pre)$(color_blue)
		color_tgt_pgm 		= $(color_pre)$(color_blue)

	# whites color scheme
	else ifeq "$(color)" "whites"
		color_pkg_banner 	= $(color_pre)$(color_bright_white)
		color_dir_banner 	= $(color_pre)$(color_white)
		color_tgt_file 		= $(color_pre)$(color_gray)
		color_tgt_lib 		= $(color_pre)$(color_bright_white)
		color_tgt_pgm 		= $(color_pre)$(color_bright_white)

	else
$(warning Warning: $(color) scheme is unsupported.)

	endif

	export color
	export color_end = $(color_post)
	export color_pkg_banner
	export color_dir_banner
	export color_tgt_file
	export color_tgt_lib
	export color_tgt_pgm
endif

ifdef RNMAKE_DOXY
/*! \endcond RNMAKE_DOXY */
endif
