#!/bin/bash

# This script runs the all benchmarks

cd $(dirname $0) # navigate to this folder
./test_c.sh
./test_affine_for.sh
./test_affine_parallel.sh
./test_sdir.sh
