#!/bin/bash

BOLD=$(tput -Txterm bold)
RED=$(tput -Txterm setaf 1)
BLUE=$(tput -Txterm setaf 6)
YELLOW=$(tput -Txterm setaf 3)
DIM=$(tput -Txterm dim)
RESET=$(tput -Txterm sgr0)
export BOLD
export RED
export BLUE
export YELLOW
export DIM
export RESET

function error() {
    echo "${BOLD}${RED}=> $1${RESET}"
}

function header1() {
    TXT=$(echo "$1" |tr '/a-z/' '/A-Z/')
    echo -e "${BOLD}***** ${TXT} *****${RESET}"
}

function header2() {
    echo -e "${BLUE}*** $1 ***${RESET}"
}

function header3() {
    echo -e "${YELLOW}* $1 *${RESET}"
}

function header4() {
    echo -e "${DIM}$1${RESET}"
}

function util() {
    if test -n "$2"; then
        if test -n "$3"; then
            $4 >/dev/null 2>&1
            if test $? -ne 0; then
                header4 "bypassing $6 with $1 (not available)"
                exit 0
            fi
            header3 "$6 with $1"
            header4 "Executing $2 $5 $3"
            # shellcheck disable=SC2086
            $2 $5 $3
            if test $? -ne 0; then
                error "$7"
                exit 1
            fi
            header3 "$6 with $1: ok"
        fi
    fi
}