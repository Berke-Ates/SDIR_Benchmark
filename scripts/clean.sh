#!/bin/bash

# This script cleans all the generated files

cd $(dirname $0)/.. #navigate to root of repo

rm -rf gen
rm -rf logs

mkdir -p logs
mkdir -p gen
