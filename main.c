#include <gmp.h>
#include <stdio.h>
#include <time.h>

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

    // Loop and print
    int isPrime = 0;
    for (int i = 0; i < 10; ++i)
    {
        while(isPrime < 1) {
            mpz_urandomb(randNum, state, 512);
            isPrime = mpz_probab_prime_p(randNum, 25);
        }
        gmp_printf("%Zd\n", randNum);
        isPrime = 0;
    }


    // Clean up, clean up, everybody do your chore...
    gmp_randclear(state);
    mpz_clear(randNum);
    return 0;
}