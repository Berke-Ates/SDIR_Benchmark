# SDIR_Benchmark
Benchmarking repository to compare SDIR against MLIR and C using PolyBench

To run simply execute `run.sh` in the root. BEWARE: The dependencies script doesn't 
check for existing installations and will reinstall MLIR and SDIR, which will take a while.

To re-run a specific benchmark execute the according script in the scripts folder.
The results of the benchmark can be found in the `logs` subfolder.
Any generated file will be placed in the `gen` subfolder.
