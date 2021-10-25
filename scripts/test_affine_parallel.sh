#!/bin/bash

# This script runs the affine.parallel benchmark
# Logs ms

cd $(dirname $0) # navigate to this folder
echo -n "Running affine.parallel benchmark..."

#--scf-for-to-while
mlir-opt --lower-affine --convert-scf-to-std "../benchmarks/affine_parallel_2mm.mlir" > "../gen/affine_parallel_std.mlir"

mlir-opt --lower-host-to-llvm "../gen/affine_parallel_std.mlir" > "../gen/affine_parallel_llvm.mlir"

mlir-translate --mlir-to-llvmir "../gen/affine_parallel_llvm.mlir" > "../gen/affine_parallel.ll"

llc -O3 -march=x86-64 -relocation-model=pic -filetype=obj "../gen/affine_parallel.ll" -o "../gen/affine_parallel.o"

clang -O3 "../gen/affine_parallel.o" -o "../gen/affine_parallel.out"

for i in {1..3}
do
  ../gen/affine_parallel.out >> "../logs/affine_parallel_benchmark.log"
done

echo -ne "\r\e[K"
echo -e "\u2705 affine.parallel benchmark"
