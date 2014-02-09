#include "bigInt.c"
#include "cuda.h"
#include "cuda_runtime_api.h"
#include "cudaFunctions.h"

#define MODULI_BUF_SIZE 2000

int main(int argc, char const *argv[])
{
    if(argc < 2) {
        fprintf(stderr, "Usage: %s <file name>\n", argv[0]);
        return -1;
    }

    bigInt **moduli = (bigInt**) malloc(MODULI_BUF_SIZE * sizeof(bigInt**));

    // Read in the bigInts
    int numModuli = readBigIntsFromFile(argv[1], moduli);

    if(numModuli < 0) {
        fprintf(stderr, "No moduli read. Exiting.\n");
        return -1;
    }

    printf("%d moduli read in.\n", numModuli);

    // send array to CUDA
    // -------------------------------------------------------------------------
    
    // int *keys;
    // cudaMalloc(keys, numModuli*sizeof(bigInt));
    // cudaMemcpy(keys, moduli, numModuli*sizeof(bigInt), cudaMemCpyDeviceToHost);

    // get back bit array
    // -------------------------------------------------------------------------

    // calculate and print results
    // -------------------------------------------------------------------------

    return 0;
}
