#include <gmp.h>
#include <stdio.h>
#include <time.h>

void euclidianGCD(mpz_t *gcd, mpz_t numA, mpz_t numB);

int main(int argc, char const *argv[])
{
    gmp_randstate_t state;
    unsigned long int i, seed = 12345;
    // Get a timestamp and use it as our seed
    // (this is generally regarded as a 'shitty idea')
    // time_t nowTime = time(0);
    // seed = (unsigned long int) rawTime;
    // Initiate random state
    gmp_randinit_default(state);
    gmp_randseed_ui(state, seed);

    // ~*magic*~
    mpz_t randNum;
    mpz_init (randNum);
    mpz_urandomb (randNum, state, 2);


    // PART 1 - create 10 512 bit primes

    // Loop and print
    // int isPrime = 0;
    // for (int i = 0; i < 10; ++i)
    // {
    //     while(isPrime < 1) {
    //         mpz_urandomb(randNum, state, 512);
    //         isPrime = mpz_probab_prime_p(randNum, 25);
    //     }
    //     gmp_printf("%Zd\n", randNum);
    //     isPrime = 0;
    // }


    // PART 2 - create GCD and test it
    mpz_t numA, numB, gcd;
    // mpz_init(numA); mpz_set_ui(numA, 65432);
    // mpz_init(numB); mpz_set_ui(numB, 23456); // 8
    mpz_init(numA); mpz_set_ui(numA, 48);
    mpz_init(numB); mpz_set_ui(numB, 18); // 22222
    mpz_init(gcd);


    euclidianGCD(&gcd, numA, numB);
    gmp_printf("GCD: %Zd\n", gcd);

    if (mpz_cmp_ui(gcd, 6) == 0)
        printf("HOOREAY!\n");

    // Clean up, clean up, everybody do your chore...
    gmp_randclear(state);
    mpz_clear(randNum);
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