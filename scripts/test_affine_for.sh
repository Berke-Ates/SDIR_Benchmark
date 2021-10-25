#!/bin/bash

# This script runs the affine.for benchmark
# Logs ms 

cd $(dirname $0) # navigate to this folder
echo -n "Running affine.for benchmark..."

#--scf-for-to-while
mlir-opt --lower-affine --convert-scf-to-std "../benchmarks/affine_for_2mm.mlir" > "../gen/affine_for_std.mlir"

mlir-opt --lower-host-to-llvm "../gen/affine_for_std.mlir" > "../gen/affine_for_llvm.mlir"

mlir-translate --mlir-to-llvmir "../gen/affine_for_llvm.mlir" > "../gen/affine_for.ll"

llc -O3 -march=x86-64 -relocation-model=pic -filetype=obj "../gen/affine_for.ll" -o "../gen/affine_for.o"

clang -O3 "../gen/affine_for.o" -o "../gen/affine_for.out"

#for i in {1..3}
#do
  ../gen/affine_for.out >> "../logs/affine_for_benchmark.log"
#done

echo -ne "\r\e[K"
echo -e "\u2705 affine.for benchmark"
