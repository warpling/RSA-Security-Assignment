#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include <time.h>

#define BIT_LENGTH 1024

void stupidPrimeGenerator(mpz_t prime, int bits, gmp_randstate_t state);

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

    // PART 4 - RSA
    // Generate p, q, n=pq, and e
    mpz_t p; mpz_init(p); stupidPrimeGenerator(p, BIT_LENGTH, state);
    mpz_t q; mpz_init(q); stupidPrimeGenerator(q, BIT_LENGTH, state);
    // mpz_set_ui(p, 61); mpz_set_ui(q, 53);
    mpz_t n; mpz_init(n); mpz_mul(n, p, q);
    mpz_t e; mpz_init(e); mpz_set_ui(e, 65537);
    // mpz_set_ui(e, 17);
    gmp_printf("p=%Zd\n\nq=%Zd\n\ne=%Zd\n\n", p, q, e);

    // Generate totient=(p-1)(q-1)
    mpz_sub_ui(p, p, 1);
    mpz_sub_ui(q, q, 1);
    mpz_t totient; mpz_init(totient); mpz_mul(totient, p, q);
    
    // Calculate d
    mpz_t negativeOne; mpz_init(negativeOne); mpz_set_si(negativeOne, -1);
    mpz_t d; mpz_init(d);
    mpz_powm(d, e, negativeOne, totient);

    gmp_printf("d=%Zd\n\nn=%Zd\n\n", d, n);

    // Read in message
    printf("Input message to be encrypted:\n");
    mpz_t inputMessage;     mpz_init(inputMessage);
    mpz_t encryptedMessage; mpz_init(encryptedMessage);
    mpz_t decryptedMessage; mpz_init(decryptedMessage);
    mpz_inp_str(inputMessage, stdin, 10);
    gmp_printf("Input message: %Zd\n", inputMessage);

    // Encrpyt message
    mpz_powm(encryptedMessage, inputMessage, e, n);
    gmp_printf("Encrypted message: %Zd\n", encryptedMessage);

    // Decrypt message
    mpz_powm(decryptedMessage, encryptedMessage, d, n);
    gmp_printf("Decrypted message: %Zd\n", decryptedMessage);
    size_t count = 1024;
    char *outputMessage = (char*) calloc(count, sizeof(char));
    mpz_export(outputMessage, &count, 1, sizeof(char), 1, 0, decryptedMessage);
    printf("%s\n", outputMessage);
}

// Generates an x bit probabalistic prime
// Requires initalized random state
void stupidPrimeGenerator(mpz_t prime, int bits, gmp_randstate_t state) {
    do {
        mpz_urandomb(prime, state, bits);
    } while(mpz_probab_prime_p(prime, 25));
}