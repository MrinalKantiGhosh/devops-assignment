#!/bin/bash

#  top -o cpu -o mem -l 1

_get_port_of_proccess() {
  PID=${PID:?"provide process id"}
  lsof -aPi -p "${PID}" -Fn | tail -n 1 | awk -F: '{print $NF}'
}

_get_process_name() {
  PID=${PID:?"provide process id"}
  ps -p "${PID}" -o comm=
}

_sort_by_cpu() {
  ps -eo pcpu,pmem,pid | awk 'NR > 1 {print $0}' | sort -r -k 1 | head -"${1}" | tail -1
}

_sort_by_mem() {
  ps -eo pcpu,pmem,pid | awk 'NR > 1 {print $0}' | sort -r -k 2 | head -"${1}" | tail -1
}

_print() {
  # "CPU MEMORY PID" "PORT" "PROCESS_NAME"
  CPU=$(echo "${result}" | awk '{print $1}')
  MEMORY=$(echo "${result}" | awk '{print $2}')
  PID=$(echo "${result}" | awk '{print $3}')

  echo "
  CPU = ${CPU}  
  MEMORY = ${MEMORY}  
  PID = ${PID} 
  PORT = ${2}  
  PROCESS_NAME = ${3}"
}

__process_details() {
  SORT_BY=${SORT_BY:?"provide value of sort-by, acepted values - cpu | mem "}
  Nth_highest=${Nth_highest:?"provide values for Nth_highest, Ex. - Nth_highest=3 means you wants 3rd highest cpu/mem consuming process"}
  
  result=$(_sort_by_"${SORT_BY}" "${Nth_highest}")
  
  CPU=$(echo "${result}" | awk '{print $1}')
  MEMORY=$(echo "${result}" | awk '{print $2}')
  PID=$(echo "${result}" | awk '{print $3}')
  
  PORT=$(PID=${PID} _get_port_of_proccess)
  PROCESS_NAME=$(PID=${PID} _get_process_name)
  
  if [[ ${PORT} == "" || -z ${PORT} ]]; then 
    PORT="Port is not available"
  fi

  _print "${result}" "${PORT}" "${PROCESS_NAME}"
}

usage_message="Usage $0 <command>\nCommands:"

CMD=${1:-}
shift || true
if __${CMD} "$@"; then ## Functions to be called as commands are prefixed with __
  exit 0
else
  echo -e "$usage_message\n$(declare -F | sed -n "s/declare -f __/ - /p")"
fi