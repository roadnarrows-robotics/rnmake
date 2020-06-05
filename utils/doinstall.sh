#!/bin/sh
# Package:  RN Makefile System Utility
# File:     doinstall.sh
# Desc:     Install files for source directory to destination directory.
# Usage:    doinstall.sh [OPTIONS] src_dir dst_dir
#
# /*! \file */
# /*! \cond RNMAKE_DOXY*/

argv0=$(basename $0)

print_help()
{
  cat <<EOH
Usage: ${argv0} [OPTIONS] SRCDIR DSTDIR
       ${argv0} --help

Install files for source directory to destination directory.

Options:
  -o, --strip-opt=OPT   Strip program option. May be iterated.
  -p, --strip-pgm=PGM   Strip program.
      --verbose         Print verbose install progress.

      --help            Print this help and exit.
EOH
}

# long and short options
longopts="strip-pgm:,strip-opt:,verbose,help"
shortopts="p:o:h"

# Option defaults
verbose=
strip_pgm=
strip_opts=

# Positional arguments
srcdir=
dstdir=

# get the command-line options
#   order returned: OPTIONS -- ARGS OTHER_OPTIONS
OPTS=$(getopt --name ${argv0} -o "${shortopts}" --long "${longopts}" -- "${@}")

if [ $? != 0 ]
then
  echo "rnmake: ${argv0}: error: bad option(s), try '${argv0} --help'" >&2
  exit 2
fi

eval set -- "${OPTS}"

# process command-line options
while true
do
  case "$1" in
    -h|--help) print_help; exit 0;;
    --verbose) verbose=1 shift;;
    -p|--strip-pgm) strip_pgm="${2}"; shift 2;;
    -o|--strip-opt) strip_opts="${strip_opts} ${2}"; shift 2;;
    --) shift; break;;
    *) break;
  esac
done

srcdir=${1}
dstdir=${2}

if [ "$srcdir" = "" ]
then
  echo "rnmake: ${argv0}: error: no source directory specified" >&2
  exit 2
fi

if [ "$dstdir" = "" ]
then
  echo "rnmake: ${argv0}: error: no destination install directory specified" >&2
  exit 2
fi

install -d -p -m 775 ${dstdir}

if ! cd ${srcdir} 2>/dev/null
then
  echo "rnmake: ${argv0}: error: cannot 'cd' to ${srcdir}" >&2
  exit 4
fi

#
# Install files
#
find . -type f -o -type l | \
grep -v \.svn | \
while read srcpath
do
  # strip leading './'
	src="${srcpath##./}"
  # destination [sub]directory name
  dname=${dstdir}/$(dirname ${src})
  # create directory if it does not exist
  if [ ! -d ${dname} ]
  then
    install -d -p -m 775 ${dname}
  fi
  # destination file name
	dst="${dstdir}/${src}"
  if [ "${verbose}" ]
  then 
	  echo "  ${dst}"
  fi
  # 'install' symlink file
  if [ -h ${srcpath} ]
  then
    lnk=$(readlink ${srcpath})
    cd ${dname} >/dev/null
    fname=$(basename ${srcpath})
    if [ ! -f ${fname} ]
    then
      ln -s ${lnk} ${fname}
    fi
    cd - >/dev/null
  # install regular file with given permissions
  else
    mode=$(stat -c '%a' ${srcpath})
    install -p -m ${mode} ${srcpath} ${dst}
    if [ -n ${strip_pgm} ]
    then
      ${strip_pgm} ${strip_opts} ${dst} >/dev/null 2>/dev/null
      if [ "${verbose}" -a ${?} = 0 ]
      then 
        echo "    ${strip_pgm} ${strip_opts} ${dst}"
      fi
    fi
  fi
done

#/*! \endcond RNMAKE_DOXY */
