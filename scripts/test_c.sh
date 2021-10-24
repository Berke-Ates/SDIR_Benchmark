#!/bin/bash

# This script runs the C benchmark

cd $(dirname $0) #navigate to this folder

clang ../benchmarks/C_2mm_builtin.c -DPOLYBENCH_TIME -o "../gen/.tempfile" &> /dev/null
./.tempfile
rm -f ".tempfile"
