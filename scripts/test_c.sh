#!/bin/bash

# This script runs the C benchmark

cd $(dirname $0) # navigate to this folder
echo -n "Running C benchmark"

clang "../benchmarks/C_2mm_builtin.c" -DPOLYBENCH_TIME -o "../gen/c_bench.out"

for i in {1..3}
do
  ../gen/c_bench.out >> "../logs/c_benchmark.log"
done

echo -ne "\r\e[K"
echo -e "\u2705 C benchmark done!"
