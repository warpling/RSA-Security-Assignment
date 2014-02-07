#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include <gmp.h>

#define MODULI_BUF_SIZE 2000

int fsize(FILE *fp);

int main(int argc, char const *argv[])
{

    if(argc < 2) {
        fprintf(stderr, "Usage: %s <file name>\n", argv[0]);
        return -1;
    }

    // read in file
    // -------------------------------------------------------------------------
    FILE *fp = fopen((char *)argv[1], "r");

    // GCD all pairs
    // -------------------------------------------------------------------------

    if (fp && !feof(fp)) {

        int numModuli;
        // int numModuli = fsize(fp);
        // printf(">>%d\n", numModuli);

        // TODO: Is this bad? Should we be mallocing?
        mpz_t *moduli = (mpz_t*) malloc(MODULI_BUF_SIZE * sizeof(mpz_t));
        int i = 0, scanResult, moduliArraySize = MODULI_BUF_SIZE;

        do {
            mpz_init(moduli[i]);
            scanResult = gmp_fscanf(fp, "%Zd", moduli[i++]);
            // Resize moduli array if necessary
            if(i == moduliArraySize) {
                // TODO: You best not read in over 2.14 billion elements
                moduliArraySize *= 2;
                moduli = (mpz_t*) realloc(moduli, (moduliArraySize * sizeof(mpz_t)));
            }  
        } while(scanResult > 0);

        numModuli = i-1;

        // for (int i = 0; i < numModuli; ++i) {
        //     mpz_init(moduli[i]);
        //     gmp_fscanf(fp, "%Zd", moduli[i]); 
        // }

        mpz_t gcd;
        mpz_init(gcd);

        for (int i = 0; i < numModuli; i++)
        {
            for (int j = (i+1); j < numModuli; j++)
            {

                mpz_clear(gcd); mpz_init(gcd);
                mpz_gcd(gcd, moduli[i], moduli[j]);

                // Debug:
                // gmp_printf("  %d <--> %d\t", i, j);
                // if(mpz_cmp_ui(gcd, 1) > 0)
                //     printf("GCD FOUND\n");
                // else
                //     printf("-       -\n");

                if(mpz_cmp_ui(gcd, 1) > 0)
                    gmp_printf("%Zd\n%Zd\n", moduli[i], moduli[j]);

            }
        }





        fclose(fp);
    }
    else {
        fprintf(stderr, "%s, doesn\'t appear to be a proper file.\n", argv[1]);
        fprintf(stderr, "Are you sure it\'s a file of moduli?\n");
        return -1;
    }







    // mpz_t numA, numB, gcd;

    // mpz_init(numA); //mpz_set_ui(numA, 48);
    // mpz_init(numB); //mpz_set_ui(numB, 18);
    // mpz_init(gcd);

    // gmp_printf("Input first number: ");
    // gmp_scanf("%Zd", numA);
    // gmp_printf("Input second number: ");
    // gmp_scanf("%Zd", numB);

    // // Calculate and print output
    // // (they separated because euclidianGCD dirties the inputs)
    // gmp_printf("GDC of %Zd and %Zd is ", numA, numB);
    // euclidianGCD(&gcd, numA, numB);
    // gmp_printf(" %Zd!\n", gcd);

    // return 0;
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

// File length function
// source: http://stackoverflow.com/questions/4278845/count-the-lines-of-a-file-in-c
int fsize(FILE *fp) {
    int ch, lines;

    while (EOF != (ch=fgetc(fp)))
        if (ch=='\n')
            ++lines;

    // Remember to rewind the VCR for the next renter!
    rewind(fp);

    // Count the last line, even if it doesn't have a trailing newline
    return (lines + 1);
}