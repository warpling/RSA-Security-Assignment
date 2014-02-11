#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <gmp.h>
#include "outputBuilder.h"

#define MODULI_BUF_SIZE 2000

int main(int argc, char const *argv[])
{

    if(argc < 2) {
        fprintf(stderr, "Usage: %s <file name>\n", argv[0]);
        return -1;
    }

    // read in file/moduli
    // -------------------------------------------------------------------------
    FILE *fp = fopen((char *)argv[1], "r");

    if (fp && !feof(fp)) {

        int numModuli;

        // TODO: Is this bad? Should we be mallocing?
        mpz_t *moduli = (mpz_t*) malloc(MODULI_BUF_SIZE * sizeof(mpz_t));
        int i = 0, scanResult, moduliArraySize = MODULI_BUF_SIZE;

        do {
            mpz_init(moduli[i]);
            scanResult = gmp_fscanf(fp, "%Zd", moduli[i++]);
            // Resize moduli array if necessary
            if(i == moduliArraySize) {
                // TODO: You best not read in over 2.14 billion elements
                moduliArraySize *= 2;
                moduli = (mpz_t*) realloc(moduli, (moduliArraySize * sizeof(mpz_t)));
            }
        } while(scanResult > 0);

        numModuli = i-1;

        // GCD all pairs
        // ---------------------------------------------------------------------

        mpz_t gcd;
        mpz_init(gcd);

        for (i = 0; i < numModuli; i++)
        {
            int j;
            for (j = (i+1); j < numModuli; j++)
            {
                mpz_clear(gcd); mpz_init(gcd);
                mpz_gcd(gcd, moduli[i], moduli[j]);

                if(mpz_cmp_ui(gcd, 1) > 0) {
                    // If it's a bad key, print its stuff
                    mpz_t privateKey; mpz_init(privateKey);
                    generatePrivateKeyFromModulusAndPrime(privateKey, moduli[i], gcd);
                    gmp_printf("%Zd:%Zd\n", moduli[i], privateKey);

                    mpz_clear(privateKey); mpz_init(privateKey);
                    generatePrivateKeyFromModulusAndPrime(privateKey, moduli[j], gcd);
                    gmp_printf("%Zd:%Zd\n", moduli[j], privateKey);
                }

            }
        }

        fclose(fp);
    }
    else {
        fprintf(stderr, "%s, doesn\'t appear to be a proper file.\n", argv[1]);
        fprintf(stderr, "Are you sure it\'s a file of moduli?\n");
        return -1;
    }
}

void euclidianGCD(mpz_t *gcd, mpz_t numA, mpz_t numB) {
 
    mpz_t quotient; mpz_init(quotient);
    mpz_t remainder; mpz_init(remainder);

    // if either number is <= 0, bail
    if (mpz_cmp_ui(numA, 0) <= 0 || mpz_cmp_ui(numB, 0) <= 0) {
        fprintf(stderr, "Cannot calculate GCD of non positive integer. GCD has not been set.\n");       
        return;
    }

    // if A is smaller than B then swap them
    if (mpz_cmp(numA, numB) < 0) {
        mpz_t temp;
        mpz_set(temp, numA);
        mpz_set(numA, numB);
        mpz_set(numB, temp);
    }

    do {
        mpz_tdiv_qr(quotient, remainder, numA, numB);

        if(mpz_cmp_ui(remainder, 0) == 0) {
            mpz_set(*gcd, numB);
            return;            
        }

        else {
            mpz_set(numA, numB);
            mpz_set(numB, remainder);
        }

    } while (mpz_cmp_ui(remainder, 0) > 0); // Should this just be while(true)
}
