PARTS  = serialGCD
OUTPUT = 256-keys.out 2048-keys.out 4096-keys.out

all: $(PARTS)

# part1: part1.c
# 	gcc part1.c -lgmp -o part1
# 	./part1

serial: serialGCD.c
	gcc serialGCD.c -lgmp -g -o serialGCD

serialTest: serial
	@echo "Testing 20,000 keys serially"
	./serialGCD keys/2K-keys.txt > 20K-keys.out

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