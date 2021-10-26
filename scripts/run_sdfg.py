# This script executes an SDFG

import dace
import sys
import json
import datetime

def init_arrays(ni,nj,nk,nl,A,B,C,D):
    for i in range(ni):
        for j in range(nk):
            A[i, j] = dace.float64((i * j + 1) % ni) / ni
    for i in range(nk):
        for j in range(nj):
            B[i, j] = dace.float64(i * (j + 1) % nj) / nj
    for i in range(nj):
        for j in range(nl):
            C[i, j] = dace.float64((i * (j + 3) + 1) % nl) / nl
    for i in range(ni):
        for j in range(nl):
            D[i, j] = dace.float64(i * (j + 2) % nk) / nk

if __name__ == '__main__':
    ni = dace.int64(800)
    nj = dace.int64(900)
    nk = dace.int64(1100)
    nl = dace.int64(1200)

    alpha = dace.float64(1.5)
    beta = dace.float64(1.2)

    tmp = dace.ndarray(shape=(ni, nj), dtype=dace.float64)
    A = dace.ndarray(shape=(ni, nk), dtype=dace.float64)
    B = dace.ndarray(shape=(nk, nj), dtype=dace.float64)
    C = dace.ndarray(shape=(nj, nl), dtype=dace.float64)
    D = dace.ndarray(shape=(ni, nl), dtype=dace.float64)

    init_arrays(ni, nj, nk, nl, A, B, C, D)

    file = open("../gen/sdir_2mm_opt.sdfg")
    translated_json = json.load(file)
    sdfg = dace.SDFG.from_json(translated_json)
    obj = sdfg.compile()

    for i in range(100):
        t_0 = datetime.datetime.now()
        obj(ni,nj,nk,nl,tmp,A,B,C,D,alpha,beta)
        t_d = datetime.datetime.now() - t_0
        
        with open("../logs/sdir_benchmark.log", "a") as logfile:
            logfile.write(str(round(t_d.total_seconds()*1000)) + "\n")
        
        print("Done sdir run: ", str(i))

        #print(round(t_d.total_seconds()*1000), " ms")
        #print(round(D[0,0],6)) # Same precision as mlir
