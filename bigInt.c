#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "gmp.h"
#include <math.h>

#define NUM_INTS_IN_BIG_INT 32
#define UINT32_LENGTH 32

typedef struct {
    uint32_t components[NUM_INTS_IN_BIG_INT];
} bigInt;

// Take in string and turn it into a 1024 bit int
void setBigIntFromString(bigInt *bigNum, char *string) {

    // Initializes 1024 bit mpz number
    mpz_t num; mpz_init2(num, (UINT32_LENGTH * NUM_INTS_IN_BIG_INT));
    // Read in base 10 string to mpz representation
    mpz_set_str(num, string, 10);

    // Create output string in base 2
    // TODO: find out why binaryString isn't getting set through the param
    char binaryString[(UINT32_LENGTH * NUM_INTS_IN_BIG_INT) + 1];
    mpz_get_str(binaryString, 2, num);
    // Debug:
    // printf("Binary String (%lu char long): %s\n", strlen(binaryString), binaryString);

    // Build dem' integer components from the binary string
    // 
    // bits within component integers are in traditional big endian,
    //   but the integers components in the components array are in little endian
    //   (ie. a number like 0xABCDEF would become [0xEF][0xCD][0xAB]) where each bracketed set is a component
    // printf("%d comps\n", (int)ceil(strlen(binaryString)/32.0));
    for (int i = 0; i < (int)ceil(strlen(binaryString)/(1.0*NUM_INTS_IN_BIG_INT)); i ++)
    {
        // component has to be shorter than what's being copied in or else strncpy won't null pad it
        char component[(NUM_INTS_IN_BIG_INT+1)] = "\0";
        strncpy(component, &binaryString[i*NUM_INTS_IN_BIG_INT], NUM_INTS_IN_BIG_INT);
        // printf("%s", component);
        bigNum->components[(NUM_INTS_IN_BIG_INT-1)-i] = atoi(component);
    }
}

printBigInt(bigInt *num) {
    for (int i = BIG_INT_COMPONENT_COUNT; i >= 0 ; --i)
        printf("%d", num->components[i]);
    printf("\n");
}
