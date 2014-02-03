#include <gmp.h>
#include <stdio.h>

int main(int argc, char const *argv[])
{
    // PART 3 - pairwise GCD of RSA moduli

    const int NUM_MODULI = 6;
    mpz_t moduli[NUM_MODULI];

    // Read in the six provided moduli from input  
    printf("Please input 6 moduli...\n");  
    for (int i = 0; i < NUM_MODULI; ++i) {
        mpz_init(moduli[i]);
        gmp_scanf("%Zd", moduli[i]);        
    }


    // Calculate GCDs between moduli until a pair is found
    mpz_t gcdResult;
    mpz_init(gcdResult);
    for (int i = 0; i < NUM_MODULI; ++i)
    {
        for (int j = i; j < NUM_MODULI; ++j)
        {
            // Don't compare to yourself
            if(i == j) continue;

            mpz_set_ui(gcdResult, 0);
            // mpz_clear(gcdResult); mpz_init(gcdResult);
            mpz_gcd(gcdResult, moduli[i], moduli[j]);
            if(mpz_cmp_ui(gcdResult, 1) > 0) {
                gmp_printf("n%d and n%d have a gcd of %Zd\n", i+1, j+1, gcdResult);
                // break;            
            }
        }
    }

}
