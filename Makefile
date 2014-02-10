PARTS  = serialGCD
OUTPUT = 256-keys.out 2048-keys.out 4096-keys.out

# CUDA_INC=-I/usr/local/cuda/common/inc
# CUDA_LIBS=-L/usr/local/cuda/lib64 -lcudart

CC = gcc
NVCC = nvcc
CUTTING_EDGE_TECHNOLOGY = -std=c99

NVCCFLAGS = -gencode arch=compute_20,code=sm_20 -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35   

GMP_LIB = -I/home/clupo/gmp/include -L/home/clupo/gmp/lib
LIBS= -lgmp
CUMP_LIB = -L/home/clupo/cump -lcump

all: $(PARTS)

main: main.cu bigInt
	nvcc -o mm_cuda -O2 $(GMP_LIB) -g $(NVCCFLAGS) main.cu bigInt.o

bigInt: bigInt.c
	$(CC) -c bigInt.c -o bigInt.o

serial: serialGCD.c
	$(CC) serialGCD.c -lgmp -g -o serialGCD

# How it know where bigInt.o is?
outputTest: outputTesting.c bigInt
	$(CC) outputTesting.c -lgmp -g -o outputTesting

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
