
#define UINT32_LENGTH 32

void printOutput (mpz_t *moduli, uint32_t *badModuliFlags, int totalModuliCount);
void generateBadModuliArray (mpz_t *badModuli, mpz_t *moduli, uint32_t *badModuliFlags);
void generatePrivateKeyFromModulusAndPrime(mpz_t privateKey, mpz_t modulus, mpz_t prime);

// Takes in a list of mpz_t bad RSA moduli and prints them alongside their private keys
// Output format per moduli/line: "<moduli>:<private key>\n"
// Makes the questionably dangerous assumptiong that badModuliFlags is always 32 uints long.
void printOutput (mpz_t *moduli, uint32_t *badModuliFlags, int totalModuliCount) {

    // badModuliFlags contains a packed set of bit flags that represent if a particular moduli is bad
    // We must first serially re-compute the GCD of the bad moduli and when we do, print them alongside their private keys

    // Generate new array of JUST BAD moduli
    mpz_t *badModuli = (mpz_t*) malloc(totalModuliCount * sizeof(mpz_t));
    int badModuliCount = 0, bitMask = 0;
    for (int i = 0; i < ceil(totalModuliCount/(1.0*UINT32_LENGTH)); ++i)
    {
        bitMask = 0x80000000;
        for (int bitCtr = 0; bitCtr < UINT32_LENGTH; ++bitCtr)
        {
            if((badModuliFlags[i] & bitMask) > 0) {
                badModuli[badModuliCount++] = moduli[i];
            }
            bitMask >>= 1;
        }
    }

    mpz_t gcd;
    mpz_init(gcd);

    // Recompute the GCDs serially
    for (i = 0; i < badModuliCount; i++)
    {
        for (int j = (i+1); j < badModuliCount; j++)
        {
            mpz_clear(gcd); mpz_init(gcd);
            mpz_gcd(gcd, moduli[i], moduli[j]);

            if(mpz_cmp_ui(gcd, 1) > 0) {

                // calculate private key
                mpz_t privateKey;
                mpz_init(privateKey);

                generatePrivateKeyFromModulusAndPrime(privateKey, badModuli[i], gcd);
                gmp_printf("%Zd:%Zd\n", badModuli[i], privateKey);
                generatePrivateKeyFromModulusAndPrime(privateKey, badModuli[j], gcd);
                gmp_printf("%Zd:%Zd\n", badModuli[j], privateKey);
            }
        }
    }
}

// void generatePrivateKeyFromModulusAndPrime(mpz_t privateKey, mpz_t modulus, mpz_t prime) {
    
// }

void generatePrivateKeyFromModulusAndPrime(mpz_t privateKey, mpz_t modulus, mpz_t prime) {

    mpz_t p; p = prime;
    mpz_t q; mpz_init(q); mpz_div(q, modulus, p);
    mpz_t n; mpz_init(n); mpz_mul(n, p, q);

    // gmp_printf("The other prime is %Zd\n", q);

    mpz_sub_ui(p, p, 1);
    mpz_sub_ui(q, q, 1);
    mpz_t e;       mpz_init(e);       mpz_set_ui(e, 65537);
    mpz_t totient; mpz_init(totient); mpz_mul(totient, p, q);
   
    // Calculate d
    mpz_t negativeOne;
    mpz_init(negativeOne);
    mpz_set_si(negativeOne, -1);
    mpz_t d; mpz_init(d);
    mpz_powm(d, e, negativeOne, totient);

    privateKey = d; 
}
