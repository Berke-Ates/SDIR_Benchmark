#!/bin/bash

# This script installs all the dependencies needed to run the benchmarks
set -e # Stop on error
cd $(dirname $0)/.. #navigate to root of repo

# Install CLI Tools
sudo apt update
sudo apt -y install python3
sudo apt -y install cmake
sudo apt -y install ninja-build
sudo apt -y install clang

# Install MLIR
git clone --depth 1 https://github.com/llvm/llvm-project
mkdir llvm-project/build
cd llvm-project/build
cmake -G Ninja ../llvm -DLLVM_ENABLE_PROJECTS=mlir -DLLVM_TARGETS_TO_BUILD="host" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON
cmake --build . --target check-mlir 
cd ../../

# Install SDIR
git clone --depth 1 https://github.com/spcl/mlir-dace/tree/sdir-to-sdfg-translation
mkdir mlir-dace/build 
cd mlir-dace/build
cmake -G Ninja .. -DMLIR_DIR=../../llvm-project/build/lib/cmake/mlir -DLLVM_EXTERNAL_LIT=../../llvm-project/build/bin/llvm-lit
cmake --build . --target check-sdir
cd ../../

# Install DaCe & pymlir
pip install dace
pip install pymlir
