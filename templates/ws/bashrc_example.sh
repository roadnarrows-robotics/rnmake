#
# bashrc_example.sh
#
# @PKG_NAME@ shell script example to be sourced in the .bashrc environment
# during interactive startup.
#
# In this example, @PKG_NAME@ will be locally installed under the workspace
# subdirectory devel. Change as necessary.
#

#echo "${BASH_SOURCE[0]}"

if [[ -f @WS@/env.sh ]]
then
  source @WS@/env.sh

  export @ID_PKG@_INSTALL_PREFIX=${@ID_PKG_WS@}/devel
fi
