#!/bin/bash

# This script runs the entire benchmark suite

cd $(dirname $0) # navigate to the folder of this script

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

chmod -R +x scripts/ # enable execution of all scripts

mkdir -p logs
mkdir -p gen

scripts/dependencies.sh
source scripts/envVars.sh
scripts/test_c.sh 
scripts/test_affine_for.sh 
scripts/test_affine_parallel.sh 
scripts/test_sdir.sh 
