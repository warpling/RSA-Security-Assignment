#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <gmp.h>

#define UINT32_LENGTH 32

void printOutput (mpz_t *badModuli, int badModuliCount);
// void printOutput(mpz_t *moduli, uint32_t *badModuliFlags, int totalModuliCount);
int generateBadModuliArray(mpz_t *badModuli, mpz_t *moduli, uint32_t *badModuliFlags, int totalModuliCount);
void generatePrivateKeyFromModulusAndPrime(mpz_t privateKey, mpz_t modulus, mpz_t prime);
