#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>

int main(int argc, char const *argv[])
{
    // PART 5
    printf("Input modulus:\n");
    mpz_t modulus; mpz_init(modulus); mpz_inp_str(modulus, stdin, 10);
    printf("Input gcd'd prime:\n");
    mpz_t p; mpz_init(p); mpz_inp_str(p, stdin, 10);
    mpz_t q; mpz_init(q); mpz_div(q, modulus, p);
    mpz_t n; mpz_init(n); mpz_mul(n, p, q);

    gmp_printf("The other prime is %Zd\n", q);

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

    mpz_t encryptedMessage; mpz_init(encryptedMessage); mpz_inp_str(encryptedMessage, stdin, 10);
    mpz_t decryptedMessage; mpz_init(decryptedMessage);
    mpz_powm(decryptedMessage, encryptedMessage, d, n);
    // gmp_printf("Decrypted message is %Zd\n", decryptedMessage);

    size_t count = 1024;
    char *outputMessage = (char*) calloc(count, sizeof(char));
    mpz_export(outputMessage, &count, 1, sizeof(char), 1, 0, decryptedMessage);
    gmp_printf("Decrypted message:%s\n", outputMessage);

}
