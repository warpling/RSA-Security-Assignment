PARTS = part1 part2 part3 part4

all: $(PARTS)

part1: part1.c
	gcc part1.c -lgmp -o part1
	./part1

part2: part2.c
	gcc part2.c -lgmp -o part2
	./part2

part3: part3.c
	gcc part3.c -lgmp -o part3
	./part3 < part3.in

part4: part4.c
	gcc part4.c -lgmp -o part4

part5: part5.c
	gcc part5.c -lgmp -o part5
	./part5 < part5.in

clean:
	rm $(PARTS)