#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <gmp.h>
#include <math.h>

typedef struct {
    uint32_t *components;
} bigInt;

// Inits a 1024 bit int
void initBigInt(bigInt *num) {
    num -> components = (uint32_t*) malloc(sizeof(uint32_t) * 32);
}

// void freeBigInt(bigInt *num) {
//     free(num->components);
// }

// Take in string and turn it into a 1024 bit int
void setBigIntFromString(bigInt *bigNum, char *string) {

    // Initializes 1024 bit mpz number
    mpz_t num; mpz_init2(num, 1024);
    // Read in base 10 string to mpz representation
    mpz_set_str(num, string, 10);

    // Create output string in base 2
    // TODO: find out why binaryString isn't getting set through the param
    char binaryString[1025];
    mpz_get_str(binaryString, 2, num);
    // Debug:
    // printf("Binary String (%lu char long): %s\n", strlen(binaryString), binaryString);

    // Prepare one of our bigInts
    // initBigInt(bigNum);

    // Build dem' integer components from the binary string
    // 
    // bits within component integers are in traditional big endian,
    //   but the integers components in the components array are in little endian
    //   (ie. a number like 0xABCDEF would become [0xEF][0xCD][0xAB]) where each bracketed set is a component
    // printf("%d comps\n", (int)ceil(strlen(binaryString)/32.0));
    for (int i = 0; i < (int)ceil(strlen(binaryString)/32.0); i ++)
    {
        // component has to be shorter than what's being copied in or else strncpy won't null pad it
        char component[33] = "\0";
        strncpy(component, &binaryString[i*32], 32);
        // printf("%s", component);
        bigNum->components[31-i] = atoi(component);
    }
}
