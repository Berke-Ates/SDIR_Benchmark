#!/bin/bash

# This script runs the C benchmark
# Logs seconds

cd $(dirname $0) # navigate to this folder
echo "Running C benchmark..."

clang -O3 "../benchmarks/C_2mm_builtin.c" -DPOLYBENCH_TIME -o "../gen/c_bench.out"

for i in {1..3}
do
  ../gen/c_bench.out >> "../logs/c_benchmark.log"
done
