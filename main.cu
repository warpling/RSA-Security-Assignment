#include "bigInt.c"
#include "cuda.h"
#include "cuda_runtime_api.h"

#define MODULI_BUF_SIZE 2000
#define MAX_LENGTH_OF_1024_BIT_NUM 311

int main(int argc, char const *argv[])
{
    if(argc < 2) {
        fprintf(stderr, "Usage: %s <file name>\n", argv[0]);
        return -1;
    }

    bigInt **moduli = (bigInt**) malloc(MODULI_BUF_SIZE * sizeof(bigInt**));

    // read in file
    // -------------------------------------------------------------------------
    FILE *fp = fopen((char *)argv[1], "r");


    // create array of bigInts
    // -------------------------------------------------------------------------
    int i = 0;
    int moduliArraySize = MODULI_BUF_SIZE;

    if (fp && !feof(fp)) {

        char bigIntString[MAX_LENGTH_OF_1024_BIT_NUM] = "\0";

        while (fgets(bigIntString, MAX_LENGTH_OF_1024_BIT_NUM, fp)) {
          
            // Trim new line
            bigIntString[strlen(bigIntString) - 1] = '\0';

            // Create bigInt
            bigInt *newBigInt = (bigInt*) malloc(sizeof(bigInt));
            initBigInt(newBigInt);
            setBigIntFromString(newBigInt, bigIntString);

            // Resize moduli array if necessary
            if(i == moduliArraySize) {
                // TODO: You best not read in over 2.14 billion elements
                moduliArraySize *= 2;
                moduli = (bigInt**) realloc(moduli, (moduliArraySize * sizeof(bigInt**)));
            }

            // Assign into moduli array
            moduli[i++] = newBigInt;
        }
    }

    fclose(fp);

    printf("%d moduli read in.\n", i);

    // send array to CUDA
    // -------------------------------------------------------------------------

    // get back bit array
    // -------------------------------------------------------------------------

    // calculate and print results
    // -------------------------------------------------------------------------

    return 0;
}
