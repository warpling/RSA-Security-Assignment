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


    // PART 1 - create 10 512 bit primes

    // Loop and print
    int isPrime = 0;
    printf("Generating 10 probabalistic primes\n");
    for (int i = 0; i < 10; ++i)
    {
        while(isPrime < 1) {
            mpz_urandomb(randNum, state, 512);
            isPrime = mpz_probab_prime_p(randNum, 25);
        }
        gmp_printf("%d) %Zd\n", i, randNum);
        isPrime = 0;
    }
}
