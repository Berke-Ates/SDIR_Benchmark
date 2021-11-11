#!/bin/bash

# This script runs the C benchmark
# Logs seconds

cd $(dirname $0) # navigate to this folder
echo "Running C benchmark..."

clang -O3 -target x86_64-linux -DEXTRALARGE_DATASET -DPOLYBENCH_TIME "../benchmarks/C_2mm_builtin.c" -o "../gen/c_bench.out"

for i in {1..100}
do
  ../gen/c_bench.out >> "../logs/c_benchmark.log"
  echo "Done C run: $i"
done

python3 convert_ms.py
