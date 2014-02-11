#include <stdint.h>
#include <gmp.h>
#define UINT32_LENGTH 32

void printOutput(mpz_t *moduli, uint32_t *badModuliFlags, int totalModuliCount);
void generateBadModuliArray(mpz_t *badModuli, mpz_t *moduli, uint32_t *badModuliFlags);
void generatePrivateKeyFromModulusAndPrime(mpz_t privateKey, mpz_t modulus, mpz_t prime);

