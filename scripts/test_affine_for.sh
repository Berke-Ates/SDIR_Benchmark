#!/bin/bash

# This script runs the affine.for benchmark
# Logs ms 

cd $(dirname $0) # navigate to this folder
echo "Running affine.for benchmark..."

./affine_pipeline.sh "affine_for"

for i in {1..100}
do
  ../gen/affine_for.out >> "../logs/affine_for_benchmark.log"
  echo "Done affine_for run: $i"
done
