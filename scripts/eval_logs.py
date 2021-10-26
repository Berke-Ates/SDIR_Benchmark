# This file evaluates the logs

import pandas as pd
import numpy as np
import scipy.stats as stats
import sys

dt = pd.read_csv(sys.argv[1], header=None)

print("Min: ", str(dt.min()[0]))
print("Max: ", str(dt.max()[0]))
print("Mean: ", str(dt.mean()[0]))
print("Median: ", str(dt.median()[0]))
print("STD: ", str(dt.std()[0]))
print("Q1: ", str(dt.quantile(q=0.25)[0]))
print("Q3: ", str(dt.quantile(q=0.75)[0]))

data = dt.values
data = data.reshape(-1)
data = np.sort(data)
N = data.shape[0]

lowCount, upCount = stats.binom.interval(0.95, N, 0.5, loc=0)
lowCount -= 1

print("95% CI: [", str(data[int(lowCount)]), ", ", str(data[int(upCount)]), "]")
