#!/bin/bash

# This script runs the SDIR benchmark

cd $(dirname $0) # navigate to this folder
echo -n "Running SDIR benchmark..."

python3 translate.py
python3 run_sdfg.py

echo -ne "\r\e[K"
echo -e "\u2705 SDIR benchmark"
