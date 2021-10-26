# This file converts logs in seconds into ms
 
file1 = open('../logs/c_benchmark.log', 'r')
Lines = file1.readlines()

for line in Lines:
    with open("../logs/c_benchmark_ms.log", "a") as logfile:
        logfile.write(str(round(float(line)*1000)) + "\n")
