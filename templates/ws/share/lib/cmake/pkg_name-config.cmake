#
# @PKG_OWNER@ 
#

# libpleistocene package
find_library(LIBPLEISTOCENE
  NAMES pleistocene
  PATHS /usr/local/lib/@PKG_NAME@
)

# all package libraries
set(@PKG_NAME@_LIBRARIES 
  ${LIBPLEISTOCENE}
)

# package include directories
set(@PKG_NAME@_INCLUDE_DIRS /usr/local/include)
