#!/bin/bash

__plan() {
  cd ./terraform || exit
  terraform init
  terraform plan
}

__apply() {
  __plan
  terraform apply -auto-approve
}

__destroy() {
  cd ./terraform || exit
  terraform destroy -auto-approve
}


usage_message="Usage $0 <command>\nCommands:"

CMD=${1:-}
shift || true
if __${CMD} "$@"; then ## Functions to be called as commands are prefixed with __
  exit 0
else
  echo -e "$usage_message\n$(declare -F | sed -n "s/declare -f __/ - /p")"
fi