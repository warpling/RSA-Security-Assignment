#include <gmp.h>
#include <string.h>

typedef struct {
    uint32_t *components;
} bigInt;

// Inits a 1024 bit int
void initBigInt(bigInt *num) {
    num -> components = (char*) malloc(sizeof(uint32_t) * 32);
}

// void freeBigInt(bigInt *num) {
//     free(num->components);
// }

// [00000000 00000000 00000000 00000000][00000000 00000000 00000000 00000000][00000000 00000000 00000000 00000000][00000000 00000000 00000000 00000000]

// Set the nth bit in num to bit
// array 0, index 0 is most significant and array 31, index 31 is the least
void setBit(bigInt *num, int n, int bit) {
    num -> components[31 - (n/32)] | (bit << (n % 31));
}

void setIntWithString(bigInt *bigNum, char *string) {
    // Take in string and turn it into a 1024 bit int
    string = "146892254592666948583089601585683631626169645157236206478363921730573253615526209760870859796594181788434695659841710725720439897885763279162093312172796553081184146204117456316407242637075616930126484608395172754491880020673693615434571144613429659762801708555304377699200762859522698292659398396390696049527";
    char *binaryString;
    // Initializes 1024 bit number
    mpz_t num; mpz_init2(num, 1024);
    // Read in base 10 string to mpz representation
    mpz_set_str(num, string, 10);
    // Create output string in base 2
    mpz_get_str(binaryString, 2, num);

    initBigInt(bigNum);

    // TODO: Eventually do this string -> num conversion on CUDA
    for (int i = strlen()-1; i >=0 ; ++i)
    {
        setBit(bigNum, i, atoi(binaryString[i]));
    }
}