#!/bin/bash

# This script runs the affine.parallel benchmark

cd $(dirname $0) # navigate to this folder

#--scf-for-to-while
mlir-opt --lower-affine --convert-scf-to-std "../benchmarks/affine_parallel_2mm.mlir" > "../gen/affine_parallel_std.mlir"

mlir-opt --lower-host-to-llvm "../gen/affine_parallel_std.mlir" > "../gen/affine_parallel_llvm.mlir"

mlir-translate --mlir-to-llvmir "../gen/affine_parallel_llvm.mlir" > "../gen/affine_parallel.ll"

llc -O3 -march=x86-64 -relocation-model=pic -filetype=obj "../gen/affine_parallel.ll" -o "../gen/affine_parallel.o"

clang -O3 "../gen/affine_parallel.o" -o "../gen/affine_parallel.out"

../gen/affine_parallel.out


