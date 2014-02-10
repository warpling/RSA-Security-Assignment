#include "bigInt.h"

int readBigIntsFromFile(const char *filename, bigInt *bigIntArray, mpz_t *mpzArray) {
    // read in file
    // --------------------------------------------------------------------
    FILE *fp = fopen(filename, "r");

    // create array of bigInts
    // --------------------------------------------------------------------
    int i = 0;
    int arraySize = BUF_SIZE;

    if (fp && !feof(fp)) {

        char bigIntString[STR_LEN_1024_BITS] = "\0";

        while (fgets(bigIntString, STR_LEN_1024_BITS, fp)) {
          
            // Trim new line
            bigIntString[strlen(bigIntString) - 1] = '\0';

            // Create bigInt and mpz_t representatio of the number
            bigInt newBigInt;
            mpz_t mpzVersion;
            mpz_init(mpzVersion);
            setBigIntFromString(&newBigInt, mpzVersion, bigIntString);

            // Resize moduli array if necessary
            if(i == arraySize) {
                // TODO: You best not read in over 2.14 billion elements
                arraySize *= 2;
                bigIntArray = (bigInt*) realloc(bigIntArray, (arraySize * sizeof(bigInt*)));
            }

            // Assign both versions of numbers into their arrays
            mpzArray[i] = mpzVersion;
            bigIntArray[i++] = newBigInt;
        }
    }
    else {
        fprintf(stderr, "Error reading in the file \'%s\'\n", filename);
        return -1;
    }

    fclose(fp);
    return i-1;
}

// Take in string and turn it into a 1024 bit int (in bigInt and mpz_t format)
void setBigIntFromString(bigInt *bigNum, mpz_t mpzNum, char *string) {

    // Initializes 1024 bit mpz number
    mpz_t num; mpz_init2(num, (UINT32_LENGTH * INTS_IN_BIG_INT));
    // Read in base 10 string to mpz representation
    mpz_set_str(num, string, 10);
    // Save off mpz_t version
    mpzNum = num;

    // Create output string in base 2
    // TODO: find out why binaryString isn't getting set through the param
    char binaryString[(UINT32_LENGTH * INTS_IN_BIG_INT) + 1];
    mpz_get_str(binaryString, 2, num);

    // zero pad the front of the string
    char paddedBinaryString[1025];
    int offset = 1024 - (strlen(binaryString));
    strncpy(&paddedBinaryString[offset], binaryString, (strlen(binaryString)));
    for (int i = 0; i < offset; ++i)
        paddedBinaryString[i] = '0';
    paddedBinaryString[1024] = '\0';


    // Debug:
    // printf("Binary String (%lu char long): %s\n", strlen(paddedBinaryString), paddedBinaryString);

    // Build the integer components from the binary string
    // 
    // bits within component integers are in traditional big endian,
    //   but the integers components in the components array are in little endian
    //   (ie. a number like 0xABCDEF would become [0xEF][0xCD][0xAB]) where each bracketed set is a component
    for (int i = 0; i < INTS_IN_BIG_INT; i++) {

        char componentString[UINT32_LENGTH] = "\0";

        strncpy(componentString, &paddedBinaryString[i*UINT32_LENGTH], UINT32_LENGTH);

        bigNum->components[(INTS_IN_BIG_INT-1)-i] = (uint32_t) strtol(componentString, NULL, 2);;
    }
}

void printBigInt(bigInt *num) {

    // concatenate component array as bits into binary string
    char binaryString[(UINT32_LENGTH * INTS_IN_BIG_INT) + 1];
    for (int i = (INTS_IN_BIG_INT - 1); i >= 0 ; --i) {
        char componentString[UINT32_LENGTH + 1];

        // Build up the binary component by hand, because artisan hand-made things are 'in'
        for (int bitCtr = 0; bitCtr < UINT32_LENGTH; ++bitCtr)
        {
            uint32_t mask = 0x01;
            mask <<= bitCtr;
            uint32_t bit = num->components[i] & mask;
            componentString[UINT32_LENGTH - 1 - bitCtr] = bit > 0 ? '1' : '0';
        }
        componentString[UINT32_LENGTH] = '\0';

        // Stop null terminating my strings you little shit
        // componentString[UINT32_LENGTH] = '\0';
        strncpy(&binaryString[(INTS_IN_BIG_INT-1-i)*UINT32_LENGTH], componentString, UINT32_LENGTH);
    }

    // Let GMP do it's thang to convert to a long int
    mpz_t convertedNum;
    mpz_init2(convertedNum, (UINT32_LENGTH * INTS_IN_BIG_INT));
    mpz_set_str(convertedNum, binaryString, 2);

    gmp_printf("%Zd\n", convertedNum);
}
