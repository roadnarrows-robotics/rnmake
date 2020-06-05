/*! \file
 *
 * \brief Swig interface definition of libpleistocene stone_tools.[hc].
 *
 * \pkgfile{@FILENAME}
 * \pkgcomponent{Python,@PKG_NAME@}
 * \author @PKG_AUTHOR@
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */


%module stone_tools
%{
#include "@PKG_NAME@/stone_tools.h"
%}

%begin
%{
/*! \file
 *  \brief Swig generated stone_tools wrapper c file.
 */
%}

/* 
 * Required RNR C types
 */
%include "@PKG_NAME@/stone_tools.h"

%include "carrays.i"
%include "cpointer.i"

%inline
%{
%}

/*
 * Higher-level python interface to the core C library.
 */
%pythoncode
%{

"""
@ORG@ @PKG_NAME@ stone tools.
"""

## \file 
## \package @PKG_NAME@.pleitocene
##
## \brief Pleistocene stone tool industries.
##
## \author @PKG_AUTHOR@
##  
## \par Copyright:
##   (C) @THIS_YEAR@ @ORG_FQ@
##   All Rights Reserved
##

%}
