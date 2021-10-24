# This scripts translates SDIR to SDFG

import sys
import subprocess
import json
from dace import SDFG

result = subprocess.run(['../../../build/bin/sdir-translate', '--mlir-to-sdfg', 
                        "../benchmarks/sdir_2mm.mlir"], stdout=subprocess.PIPE)

if(result.returncode != 0):
    exit(1)

translated = result.stdout.decode('utf-8')
translated_json = json.loads(translated)

sdfg = SDFG.from_json(translated_json)
sdfg.save(filename="../gen/sdir_2mm.sdfg", use_pickle=False, hash=None, exception=None)
