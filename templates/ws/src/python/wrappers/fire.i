/*! \file
 *
 * \brief Swig interface definition of libpleistocene fire.[hc].
 *
 * \pkgfile{@FILENAME}
 * \pkgcomponent{Python,@PKG_NAME@}
 * \author @PKG_AUTHOR@
 *
 * \LegalBegin
 * @PKG_LICENSE@
 * \LegalEnd
 */


%module fire
%{
#include "@PKG_NAME@/fire.h"
%}

%begin
%{
/*! \file
 *  \brief Swig generated fire wrapper c file.
 */
%}

/* 
 * Required RNR C types
 */
%include "@PKG_NAME@/fire.h"

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
@ORG@ @PKG_NAME@ fire.
"""

## \file 
## \package @PKG_NAME@.pleistocene
##
## \brief Pleistocene fire techniques.
##
## \author @PKG_AUTHOR@
##  
## \par Copyright:
##   (C) @THIS_YEAR@ @ORG_FQ@
##   All Rights Reserved
##

%}
