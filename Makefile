all:
	nvcc -o rsaCuda -pg ~clupo/gmp/lib/libgmp.a -g -gencode arch=compute_20,code=sm_20 -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 main.cu bigInt.cu cudaFunctions.cu 

