#!/bin/sh
# Package:  RN Makefile System Utility
# File:     src-filter.sh
# Desc:     Filters package, excluding all non-source files
# Usage:    src-filter.sh <root>
#
# /*! \file */
# /*! \cond RNMAKE_DOXY*/

root="${1}"

# escape a path for gawk re's
esc()
{
  p=$1
  r=''
  while [ -n "${p}" ]
  do
    q=${p#?}
    c=${p%"${q}"}
    case "${c}" in
      /|.)  r="$r\\$c";;
      *)    r="$r$c";;
    esac
    p=$q
  done
  echo $r
}

# 
# Recurse through directories and filter out "non-source" files and directories.
# In awk, regular expression rules are compared against the input records until
# one fires which will execute the associated action. Actions are:
#   'next' skips current record (i.e. filter out from stream)
#   'print $0' prints the line (i.e. allow).
# Note: Order is important. The last record allows all unfiltered lines to be
#       included. Keep last.
#
find ${root} -print | \
gawk "
  /^\.$/              { next }
  /\.git/             { next }
  /\.gitignore/       { next }
  /\.svn/             { next }
  /\.deps/            { next }
  /\/obj/             { next }
  /\/loc/             { next }
  /\/dist/            { next }
  /\/devel/           { next }
  /\/build/           { next }
  /\/hw/              { next }
  /\/fw/              { next }
  /\/os/              { next }
  /$(esc ${root}/3rdparty)/     { next }
  /$(esc ${root}/third_party)/  { next }
  /$(esc ${root}/rnmake)/       { next }
  /\.exe/             { next }
  /\.a/               { next }
  /\.so/              { next }
  /\.dll/             { next }
  /\.o/               { next }
  /\.out/             { next }
  /\.log/             { next }
  /\/__pycache__/       { next }
  /\.pyc/             { next }
  /\.pyo/             { next }
  /\.done/            { next }
  /.*/                { print \$0 }"
