PARTS = part1 part2 part3

all: $(PARTS)

$(PARTS):%:%.c
	gcc $@.c -lgmp -o $@
	./$@

part3:%:%.c
	gcc $@.c -lgmp -o $@
	./$@ < six_moduli

clean:
	rm $(PARTS)

# part1: part1.c
# 	gcc