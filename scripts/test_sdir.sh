#!/bin/bash

# This script runs the SDIR benchmark

cd $(dirname $0) #navigate to this folder

python translate.py
python run_sdfg.py
