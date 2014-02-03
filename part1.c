#include <gmp.h>
#include <stdio.h>
#include <time.h>

void stupidPrimeGenerator(mpz_t prime, gmp_randstate_t state);

int main(int argc, char const *argv[])
{
    gmp_randstate_t state;
    unsigned long int i, seed;
    // Get a timestamp and use it as our seed
    // (this is generally regarded as a 'bad idea')
    time_t nowTime = time(0);
    seed = (unsigned long int) nowTime;

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
        stupidPrimeGenerator(randNum, state);
        gmp_printf("%d) %Zd\n", i, randNum);
    }
}

// Generates a 512 bit probabalistic prime
// Requires initalized random state
void stupidPrimeGenerator(mpz_t prime, gmp_randstate_t state) {
    do {
        mpz_urandomb(prime, state, 512);
    } while(mpz_probab_prime_p(prime, 25));
}
