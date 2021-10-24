#!/bin/bash

# This script installs all the dependencies needed to run the benchmarks
cd $(dirname $0)/.. #navigate to root of repo

out=/dev/null 
#out=/dev/stdout # Uncomment for verbose

# Install CLI Tools
echo -n "Installing CLI tools..."
sudo apt-get update &> $out
sudo apt-get -y install python3 pip cmake ninja-build clang lld &> $out
pip install dace &> $out
echo -ne "\r\e[K"
echo -e "\u2705 Installing CLI tools"

# Install MLIR
echo -n "Cloning MLIR..."
git clone --depth 1 https://github.com/llvm/llvm-project &> $out
echo -ne "\r\e[K"
echo -e "\u2705 Cloning MLIR"

echo -n "Building MLIR..."
mkdir -p llvm-project/build
cd llvm-project/build
cmake -G Ninja ../llvm -DLLVM_ENABLE_PROJECTS="mlir" -DLLVM_TARGETS_TO_BUILD="host" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON -DLLVM_INSTALL_UTILS=ON &> $out
cmake --build . --target llc &> $out
echo -ne "\r\e[K"
echo -e "\u2705 Building MLIR"

echo -n "Testing MLIR..."
cmake --build . --target check-mlir &> $out
if [ $? ] 
then
    echo -ne "\r\e[K"
    echo -e "\u2705 Testing MLIR"
else
    echo -ne "\r\e[K"
    echo -e "\u274c Testing MLIR"
fi

export PATH="$PATH:$PWD/bin" 
cd ../../

# Install SDIR
echo -n "Cloning SDIR..."
git clone https://github.com/spcl/mlir-dace &> $out
cd mlir-dace
git checkout origin/sdir-to-sdfg-translation &> $out
echo -ne "\r\e[K"
echo -e "\u2705 Cloning SDIR"

echo -n "Building SDIR..."
mkdir -p build
cd build
cmake -G Ninja .. -DMLIR_DIR="$PWD/../llvm-project/build/lib/cmake/mlir" -DLLVM_EXTERNAL_LIT="$PWD/../../llvm-project/build/bin/llvm-lit" &> $out
cmake --build . &> $out
echo -ne "\r\e[K"
echo -e "\u2705 Building SDIR"

echo -n "Testing SDIR..."
cmake --build . --target check-sdir &> $out
if [ $? ] 
then
    echo -ne "\r\e[K"
    echo -e "\u2705 Testing SDIR"
else
    echo -ne "\r\e[K"
    echo -e "\u274c Testing SDIR"
fi

cd ../../

# Install DaCe
echo -n "Cloning DaCe..."
git clone https://github.com/Berke-Ates/dace &> $out
cd dace
git checkout origin/mlir_tasklet &> $out
echo -ne "\r\e[K"
echo -e "\u2705 Cloning DaCe"

export PYTHONPATH="$PWD/dace"
cd ..


