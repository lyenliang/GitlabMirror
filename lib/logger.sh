#!/bin/bash

source ./consts/colors.sh
readonly LOG_DIR=$(dirname "${LOG_PATH}")

# $1: variable name
# global: LOG_PATH
function log_debug {
  local _TS=`date "+%Y/%m/%d %H:%M:%S"` # timestamp
  printf "${BOLD}${GREEN}${_TS} DEBUG \"${1}\"${RESTORE}\n"

  if [ "$LOG_PATH" != "" ] && [ -d "${LOG_DIR}" ]; then
    printf "${_TS} DEBUG \"${1}\"" >> ${LOG_PATH}
  fi
}

# $1: message
# global: LOG_PATH
function log_info {
  _TS=`date "+%Y/%m/%d %H:%M:%S"`
  printf "${_TS} INFO \"${1}\"\n"

  if [ "$LOG_PATH" != "" ] && [ -d "${LOG_DIR}" ]; then
    printf "${_TS} INFO \"${1}\"\n" >> ${LOG_PATH}
  fi
}

# $1: message
# global: LOG_PATH
function log_warn {
  _TS=`date "+%Y/%m/%d %H:%M:%S"`
  printf "${BOLD}${YELLOW}${_TS} WARN \"${1}\"${RESTORE}\n"

  if [ "$LOG_PATH" != "" ] && [ -d "${LOG_DIR}" ]; then
    printf "${_TS} WARN \"${1}\"\n" >> ${LOG_PATH}
  fi
}

# $1: message
# global: LOG_PATH
function log_error {
  _TS=`date "+%Y/%m/%d %H:%M:%S"`
  printf "${BOLD}${RED}${_TS} ERROR \"${1}\"${RESTORE}\n"

  if [ "$LOG_PATH" != "" ] && [ -d "${LOG_DIR}" ]; then
    printf "${_TS} ERROR ${1}\n" >> "${LOG_PATH}"
  fi
}
