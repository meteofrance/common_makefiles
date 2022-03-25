#!/bin/bash

# paranoid mode
set -eu

# some vars
ORG=meteofrance
REPO=common_makefiles
GIT="${GIT:-git}"
GIT_CLONE_DEPTH_1="${GIT} clone --depth 1"
COMMON_MAKEFILES_GIT_URL="https://github.com/${ORG}/${REPO}.git"
CLONETMPDIR=.common_makefiles.tmp$$
TARGET=.common_makefiles

# some tests
"${GIT}" --help >/dev/null 2>&1
if [ $? -ne 0; ]; then
    echo "ERROR: git not available"
    exit 1
fi

# action
rm -Rf "${CLONETMPDIR}"
mkdir "${CLONETMPDIR}"
cd "${CLONETMPDIR}"
"${GIT_CLONE_DEPTH_1}" "${COMMON_MAKEFILES_GIT_URL}" 
rm -Rf "../${TARGET}"
cp -Rf common_makefiles/dist "../${TARGET}"
cd ..
rm -Rf "${CLONETMPDIR}"
echo
echo "=> OK: common_makefiles installed in ${TARGET}"
