#!/bin/bash

# Reference: http://wiki.bash-hackers.org/scripting/terminalcodes

readonly RESTORE="$(tput sgr0)"

readonly BLACK="$(tput setaf 0)"
readonly RED="$(tput setaf 1)"
readonly GREEN="$(tput setaf 2)"
readonly YELLOW="$(tput setaf 3)"
readonly BLUE="$(tput setaf 4)"
readonly MAGENTA="$(tput setaf 5)"
readonly CYAN="$(tput setaf 6)"
readonly WHITE="$(tput setaf 7)"
readonly DEFAULT="$(tput setaf 9)"

readonly BOLD="$(tput bold)"
readonly INVIS="$(tput invis)"
