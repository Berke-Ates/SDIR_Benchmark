#!/bin/bash

# This script runs the SDIR benchmark
# Logs ms

cd $(dirname $0) # navigate to this folder
echo "Running SDIR benchmark..."

python3 translate.py
python3 run_sdfg.py

