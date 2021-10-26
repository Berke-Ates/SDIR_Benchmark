#!/bin/bash

# This script runs the affine.for benchmark
# Logs ms 

cd $(dirname $0) # navigate to this folder
echo "Running affine.for benchmark..."

./affine_pipeline "affine_for"

for i in {1..3}
do
  ../gen/affine_for.out >> "../logs/affine_for_benchmark.log"
done
