#!/bin/bash

# This script executes the affine pipeline and saves all files in gen/

cd $(dirname $0) # navigate to this folder
name=$1

# affine passes
mlir-opt --affine-loop-tile "../benchmarks/${name}_2mm.mlir" > "../gen/${name}_opt1.mlir"
mlir-opt --affine-loop-unroll-jam "../gen/${name}_opt1.mlir" > "../gen/${name}_opt2.mlir"
mlir-opt --affine-loop-invariant-code-motion "../gen/${name}_opt2.mlir" > "../gen/${name}_opt3.mlir"
mlir-opt --affine-super-vectorize "../gen/${name}_opt3.mlir" > "../gen/${name}_opt4.mlir"
mlir-opt --affine-loop-normalize "../gen/${name}_opt4.mlir" > "../gen/${name}_opt5.mlir"
mlir-opt --affine-parallelize "../gen/${name}_opt5.mlir" > "../gen/${name}_opt6.mlir"
mlir-opt --affine-loop-fusion "../gen/${name}_opt6.mlir" > "../gen/${name}_opt7.mlir"
mlir-opt --lower-affine "../gen/${name}_opt7.mlir" > "../gen/${name}_scf.mlir"

# scf passes
#mlir-opt --convert-scf-to-openmp "../gen/${name}_scf.mlir" > "../gen/${name}_mp.mlir"
#mlir-opt --convert-openmp-to-llvm "../gen/${name}_mp.mlir" > "../gen/${name}_mp2.mlir"
mlir-opt --convert-scf-to-std "../gen/${name}_scf.mlir" > "../gen/${name}_std.mlir"

# Lower
mlir-opt --lower-host-to-llvm "../gen/${name}_std.mlir" > "../gen/${name}_llvm.mlir"
mlir-translate --mlir-to-llvmir "../gen/${name}_llvm.mlir" > "../gen/${name}.ll"
llc -O3 -march=x86-64 -relocation-model=pic -filetype=obj "../gen/${name}.ll" -o "../gen/${name}.o"
clang -O3 "../gen/${name}.o" -o "../gen/${name}.out"
