PARTS = part1 part2 part3 part4 part5

all: $(PARTS)

part1: part1.c
	gcc part1.c -lgmp -o part1

part2: part2.c
	gcc part2.c -lgmp -o part2

part3: part3.c
	gcc part3.c -lgmp -o part3

part4: part4.c
	gcc part4.c -lgmp -o part4

part5: part5.c
	gcc part5.c -lgmp -o part5

tests: $(PARTS)
	@echo "\n\nPart 1\n----------------------"
	./part1

	@echo "\n\nPart 2\n----------------------"
	./part2 < part2.in

	@echo "\n\nPart 3\n----------------------"
	./part3 < part3.in

	@echo "\n\nPart 4\n----------------------"
	./part4 < part4.in

	@echo "\n\nPart 5\n----------------------"
	./part5 < part5.in

	@echo "\n"

clean:
	rm $(PARTS)