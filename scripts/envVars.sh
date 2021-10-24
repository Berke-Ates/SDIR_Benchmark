#!/bin/bash

# This script exports the needed environmental variables
cd $(dirname $0)/.. #navigate to root of repo

export PATH="$PATH:$PWD/llvm-project/build/bin" 
export PATH="$PATH:$PWD/mlir-dace/build/bin"
export PYTHONPATH="$PWD/dace"

cd SDIR_Benchmark
