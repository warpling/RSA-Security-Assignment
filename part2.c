#include <gmp.h>
#include <stdio.h>

void euclidianGCD(mpz_t *gcd, mpz_t numA, mpz_t numB);

int main(int argc, char const *argv[])
{
    // PART 2 - create GCD and test it
    
    mpz_t numA, numB, gcd;

    mpz_init(numA); mpz_set_ui(numA, 48);
    mpz_init(numB); mpz_set_ui(numB, 18);
    mpz_init(gcd);

    gmp_printf("GDC of %Zd and %Zd is...", numA, numB);

    euclidianGCD(&gcd, numA, numB);

    if (mpz_cmp_ui(gcd, 6) == 0)
        gmp_printf("%Zd!\n", gcd);
    else
        printf("unknown!");

    return 0;
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
        printf("Swapping the numbers...\n");
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