#!/bin/bash

# This script runs the all benchmarks

cd $(dirname $0) # navigate to this folder
./test_c
./test_affine_for
./test_affine_parallel
./test_sdir
