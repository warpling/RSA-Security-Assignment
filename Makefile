CC = gcc
NVCC = nvcc
CUTTING_EDGE_TECHNOLOGY = -std=c99

NVCCFLAGS = -gencode arch=compute_20,code=sm_20 -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35   

GMP_LIB = -I/home/clupo/gmp/include -L/home/clupo/gmp/lib -lgmp
CUMP_LIB = -L/home/clupo/cump -lcump

parallel:
	LD_LIBRARY_PATH=/home/clupo/gmp/lib
	nvcc -o rsaCuda -pg ~clupo/gmp/lib/libgmp.a -g $(GMP_LIB) $(LIBS) $(NVCCFLAGS) main.cu bigInt.cu cudaFunctions.cu outputBuilder.cu

serial: serialGCD.cu
	LD_LIBRARY_PATH=/home/clupo/gmp/lib
	$(NVCC) -o serialGCD -O2 $(GMP_LIB) -lm -g serialGCD.cu outputBuilder.cu

# main: main.cu bigInt
	# $(NVCC) -o mm_cuda -O2 $(GMP_LIB) -g $(NVCCFLAGS) main.cu bigInt.o

bigInt: bigInt.cu
	$(NVCC) -c bigInt.cu $(GMP_LIB) $(LIBS) -g $(NVCCFLAGS) -o bigInt.o

cudaFunctions: cudaFunctions.cu
	$(NVCC) -o cudaFunctions.o -O2 $(GMP_LIB) $(LIBS) -g $(NVCCFLAGS) -c cudaFunctions.cu

outputTest: outputTesting.cu bigInt
	$(NVCC) outputTesting.cu $(GMP_LIB) $(LIBS) -g -o outputTesting

serialTest: serial
	@echo "Testing 20,000 keys serially"
	./serialGCD keys/2000keys.txt > 2000-keys.out

serialTestSmall: serial
	@echo "Testing 256 keys serially:"
	./serialGCD keys/256-keys.txt > 256-keys.out
	@echo "Diffing results:"
	diff -bw 256-keys.out keys/256-badkeys.txt 

serialTestMedium: serial
	@echo "Testing 2048 keys serially:"
	./serialGCD keys/2048-keys.txt > 2048-keys.out
	@echo "Diffing results:"
	diff -bw 2048-keys.out keys/2048-badkeys.txt

serialTestLarge: serial
	@echo "Testing 4096 keys serially"
	./serialGCD keys/4096-keys.txt > 4096-keys.out
	@echo "Diffing results:"
	diff -bw 4096-keys.out keys/4096-badkeys.txt

clean:
	rm $(PARTS) $(OUTPUT)
