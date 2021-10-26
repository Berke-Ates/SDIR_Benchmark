# This scripts translates SDIR to SDFG

import sys
import subprocess
import json
import dace
from dace.transformation.auto.auto_optimize import auto_optimize

result = subprocess.run(['sdir-translate', '--mlir-to-sdfg', 
                        "../benchmarks/sdir_2mm.mlir"], stdout=subprocess.PIPE)

if(result.returncode != 0):
    exit(1)

translated = result.stdout.decode('utf-8')
translated_json = json.loads(translated)

sdfg = SDFG.from_json(translated_json)
sdfg.save(filename="../gen/sdir_2mm.sdfg", use_pickle=False, hash=None, exception=None)

auto_optimize(sdfg, dace.DeviceType.CPU)
sdfg.save(filename="../gen/sdir_2mm_opt.sdfg", use_pickle=False, hash=None, exception=None)
