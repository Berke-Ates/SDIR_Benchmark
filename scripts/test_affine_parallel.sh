#!/bin/bash

# This script runs the affine.parallel benchmark
# Logs ms

cd $(dirname $0) # navigate to this folder
echo "Running affine.parallel benchmark..."

./affine_pipeline.sh "affine_parallel"

for i in {1..100}
do
  ../gen/affine_parallel.out >> "../logs/affine_parallel_benchmark.log"
  echo "Done affine_parallel run: $i"
done

