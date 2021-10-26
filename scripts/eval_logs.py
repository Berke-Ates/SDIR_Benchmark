# This file evaluates the logs

import pandas as pd
import sys

dt = pd.read_csv(sys.argv[1], header=None)

print("Min: ", str(dt.min()[0]))
print("Max: ", str(dt.max()[0]))
print("Mean: ", str(dt.mean()[0]))
print("Median: ", str(dt.median()[0]))
print("Variance: ", str(dt.var()[0]))
print("STD: ", str(dt.std()[0]))

