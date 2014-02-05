#include "bigInt.c"

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
    FILE *fp = fopen((char *)argv[1], "r");

    int i = 0;
    int moduliArraySize = MODULI_BUF_SIZE;

    // create array ofbigInts
    if (fp && !feof(fp)) {

        char bigIntString[MAX_LENGTH_OF_1024_BIT_NUM] = "\0";

        while (fgets(bigIntString, MAX_LENGTH_OF_1024_BIT_NUM, fp)) {
            // Trim new line
            bigIntString[strlen(bigIntString) - 1] = '\0';
            // fprintf(stderr, "Just read in: %s\n", bigIntString);

            bigInt *newBigInt = (bigInt*) malloc(sizeof(bigInt));
            initBigInt(newBigInt);

            setBigIntFromString(newBigInt, bigIntString);

            // Resize moduli array if necessary
            if(i == moduliArraySize) {
                // TODO: You best not read in over 2.14 billion elements
                moduliArraySize *= 2;
                moduli = (bigInt**) realloc(moduli, (moduliArraySize * sizeof(bigInt**)));
            }

            moduli[i++] = newBigInt;
        }
    }
    printf("%d moduli read in.\n", i);

    fclose(fp);
    // send array to CUDA

    // get back bit array
    // print results





    // bigInt *foo = (bigInt*) malloc(sizeof(bigInt));

    // initBigInt(foo);

    // char testNumStr[1024] = "146892254592666948583089601585683631626169645157236206478363921730573253615526209760870859796594181788434695659841710725720439897885763279162093312172796553081184146204117456316407242637075616930126484608395172754491880020673693615434571144613429659762801708555304377699200762859522698292659398396390696049527";
    // setBigIntFromString(foo, testNumStr);

    return 0;
}