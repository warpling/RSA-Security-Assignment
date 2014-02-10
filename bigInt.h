#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "gmp.h"
#include <math.h>

#define INTS_IN_BIG_INT 32
#define UINT32_LENGTH 32
#define BUF_SIZE 21000
#define STR_LEN_1024_BITS 311

typedef struct {
    uint32_t components[INTS_IN_BIG_INT];
} bigInt;

int readBigIntsFromFile(const char *filename, bigInt *bigIntArray);
void setBigIntFromString(bigInt *bigNum, char *string);
void printBigInt(bigInt *num);

