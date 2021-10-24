#!/bin/bash

# This script runs the entire benchmark suite

cd $(dirname $0) # navigate to the folder of this script

chmod -R +x scripts/ # enable execution of all scripts

mkdir -p logs
mkdir -p gen

scripts/dependencies.sh
scripts/test_c.sh 
scripts/test_affine_for.sh 
scripts/test_affine_parallel.sh 
scripts/test_sdir.sh 
