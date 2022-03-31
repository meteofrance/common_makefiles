#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

util "$1" "$2" "$3" "$4" "$5" "linting" "${6:-ERROR detected with $1 linter}"