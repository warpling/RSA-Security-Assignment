#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include <time.h>

#define BIT_LENGTH 512

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

    // Generate p, q, and n
    mpz_t p; mpz_init(p); stupidPrimeGenerator(p, BIT_LENGTH, state);
    mpz_t q; mpz_init(q); stupidPrimeGenerator(q, BIT_LENGTH, state);
    mpz_t n; mpz_init(n); mpz_mul(n, p, q);

    // Generate e and totient
    mpz_sub_ui(p, p, 1);
    mpz_sub_ui(q, q, 1);
    mpz_t e; mpz_init(e); mpz_set_ui(e, 65537);
    mpz_t totient; mpz_init(totient); mpz_mul(totient, p, q);

    // Debug:
    // gmp_printf("p=%Zd\n\nq=%Zd\n\ne=%Zd\n\n", p, q, e);
    
    // Calculate d
    mpz_t negativeOne; mpz_init(negativeOne); mpz_set_si(negativeOne, -1);
    mpz_t d; mpz_init(d);
    mpz_powm(d, e, negativeOne, totient);

    // Debug:
    // gmp_printf("d=%Zd\n\nn=%Zd\n\n", d, n);

    mpz_t inputMessage;     mpz_init(inputMessage);
    mpz_t encryptedMessage; mpz_init(encryptedMessage);
    mpz_t decryptedMessage; mpz_init(decryptedMessage);

    // Read in message
    printf("Input message: ");
    mpz_inp_str(inputMessage, stdin, 10);

    // Encrpyt message
    mpz_powm(encryptedMessage, inputMessage, e, n);
    gmp_printf("\nEncrypted message: %Zd\n\n", encryptedMessage);

    // Decrypt message
    mpz_powm(decryptedMessage, encryptedMessage, d, n);
    gmp_printf("Decrypted message: %Zd\n\n", decryptedMessage);

    // size_t count = 1024;
    // char *outputMessage = (char*) calloc(count, sizeof(char));
    // mpz_export(outputMessage, &count, 1, sizeof(char), 1, 0, decryptedMessage);
    // gmp_printf("Decrypted message:%d\n", outputMessage);
}

// Generates an x bit probabalistic prime
// Requires initalized random state
void stupidPrimeGenerator(mpz_t prime, int bits, gmp_randstate_t state) {
    do {
        mpz_urandomb(prime, state, bits);
    } while(mpz_probab_prime_p(prime, 25) < 1);
}