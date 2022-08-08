#!/bin/bash
#
#This script is for me to safely forget to format, validate, and test my tf code

#Globals
FORMAT=false
TEST=false
VALIDATE=false
if [ -z "$1" ]; then
    DIR=$(pwd)
fi

#######################################
# Shows script usage
# Globals:
#   None
# Arguments:
#   None
#######################################
usage(){
  printf "usage: lazy-tf [options] [DIR]\n
    If DIR is not specified the the current working directory willbe used.\n
Options:
    -h: Prints usage\n
    -f: Directories depth to be processed. (default 3)\n
    -t: Test the terraform code executing a plan, apply and destroy\n
    -v: Path to the root folder that will be used (default .)"
  exit 1
}

#######################################
# Shows get script options
# Globals:
#   FORMAT,VALIDATE,TEST
# Arguments:
#   -v,-f,-t
#######################################
while getopts "fhtv" o; do 
  case "${o}" in
    f) FORMAT=true ;;
    h) usage ;;
    t) TEST=true ;;
    v) VALIDATE=true ;;
    *) usage ;;
  esac
done

#######################################
# Excute the tf actions on DIR
# Globals:
#   FORMAT,VALIDATE,TEST
# Arguments:
#   none
#######################################

lazy(){
    if "${FORMAT}"; then
        terraform fmt "${DIR}"
        #simple validation
        terraform validate -backend=false "${DIR}"
    fi

    if "${VALIDATE}"; then
        #better validation than validate command ¯\_(ツ)_/¯
        terraform plan -detailed-exitcode -compact-warnings -refresh=false -lock=false
        #on destroy mode
        terraform plan -destroy -detailed-exitcode -compact-warnings -refresh=false -lock=false
    fi

    if "${TEST}"; then
        #TBD using localstack w/ terratest
        echo "testing stuff"
        #terraform init -backend=false
    fi
}

#run
lazy
