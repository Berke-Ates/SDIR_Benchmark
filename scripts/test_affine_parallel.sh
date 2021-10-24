#!/bin/bash

# This script runs the affine.parallel benchmark

cd $(dirname $0) #navigate to this folder

clean(){
    rm -f ".tempfile.affine.mlir"
    rm -f ".tempfile.mlir"
    rm -f ".tempfile.ll"
    rm -f ".tempfile.o"
    rm -f ".tempfile.out"
    echo $2
    exit $1
}

check(){
    if [ $1 -ne 0 ]; then
        clean 1 "$2"
    fi
}

#--scf-for-to-while
mlir-opt --lower-affine --convert-scf-to-std $1 > ".tempfile.affine.mlir"
check $? "Lowering affine failed"

mlir-opt --lower-host-to-llvm ".tempfile.affine.mlir" > ".tempfile.mlir"
check $? "Lowering failed"

mlir-translate --mlir-to-llvmir ".tempfile.mlir" > ".tempfile.ll"
check $? "Translation failed"

llc -O3 -march=x86-64 -relocation-model=pic -filetype=obj ".tempfile.ll" -o ".tempfile.o"
check $? "LLC failed"

clang -O3 ".tempfile.o" -o ".tempfile.out"
check $? "Clang failed"

./.tempfile.out
clean 0 ""


