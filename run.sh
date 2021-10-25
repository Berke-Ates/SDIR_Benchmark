#!/bin/bash

# This script runs the entire benchmark suite

cd $(dirname $0) # navigate to the folder of this script

# enable execution of all scripts
chmod +x scripts/dependencies.sh
chmod +x scripts/envVars.sh
chmod +x scripts/test_c.sh 
chmod +x scripts/test_affine_for.sh 
chmod +x scripts/test_affine_parallel.sh 
chmod +x scripts/test_sdir.sh  

mkdir -p logs
mkdir -p gen

scripts/dependencies.sh
source scripts/envVars.sh
scripts/test_c.sh 
scripts/test_affine_for.sh 
scripts/test_affine_parallel.sh 
scripts/test_sdir.sh 
