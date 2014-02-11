#include "bigInt.c"

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
    // else {
    //     printf("%d moduli read in.\n", numModuli);
    // }

    // --------------------------------------------------------

    for (int i = 0; i < 255; ++i)
    {
        printBigInt(moduli[i]);
    }

    return 0;
}
