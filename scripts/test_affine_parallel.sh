#!/bin/bash

# This script runs the affine.parallel benchmark
# Logs ms

cd $(dirname $0) # navigate to this folder
echo "Running affine.parallel benchmark..."

./affine_pipeline "affine_parallel"

for i in {1..3}
do
  ../gen/affine_parallel.out >> "../logs/affine_parallel_benchmark.log"
done

