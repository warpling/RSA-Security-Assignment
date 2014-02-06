#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define LSB_MASK 0x00000001
#define MSB_MASK 0x80000000
#define BITS_IN_INT 32

void shiftLeft(unsigned int *num, int count);
void shiftRight(unsigned int *num, int count);
int greaterThanOrEqualTo(unsigned int *numA, unsigned int *numB, int count);
void subtract(unsigned int *numA, unsigned int *numB, unsigned int *difference, int count);

int main(int argc, char const *argv[])
{
    // Test left shift
    unsigned int testBigInt[4] = {0x01, 0x01, 0x01, 0x01};
    printf("%u,%u,%u,%u << 1 = ", testBigInt[0], testBigInt[1], testBigInt[2], testBigInt[3]);
    shiftLeft(testBigInt, 4);
    printf("%u,%u,%u,%u\n", testBigInt[0], testBigInt[1], testBigInt[2], testBigInt[3]);
    
    // Test right shift
    printf("%u,%u,%u,%u >> 1 = ", testBigInt[0], testBigInt[1], testBigInt[2], testBigInt[3]);
    shiftRight(testBigInt, 4);
    printf("%u,%u,%u,%u\n", testBigInt[0], testBigInt[1], testBigInt[2], testBigInt[3]);
    return 0;

    // 
}

// Number 12345678
// Note to self: [12][34][56][78]
// Note to self: [78][56][34][12]
// Note to self: [87][65][43][21]

void shiftLeft(unsigned int *num, int count) {
    int i;
    for (i = count-1; i > 0; i--)
    {
        // shift current byte one bit right
        num[i] = num[i] >> 1;
        // grab lsb of byte to the left
        unsigned int lsb = num[i-1] & LSB_MASK;
        lsb = lsb << (BITS_IN_INT - 1);
        // carry the lsb bit from i-1 to i
        num[i] = num[i] | lsb;
    }
    // shift int 0 right 1 bit
    num[i] = num[i] >> 1;
}

void shiftRight(unsigned int *num, int count) {
    int i;
    for (i = 0; i < count-1; i++)
    {
        // shift current byte one bit left
        num[i] = num[i] << 1;
        // grab msb of byte to the right
        unsigned int msb = num[i+1] & MSB_MASK;
        msb = msb >> (BITS_IN_INT - 1);
        // carry the msb bit from i+1 to i
        num[i] = num[i] | msb;
    }
    // shift int 0 right 1 bit
    num[i] = num[i] << 1;
}

// Broken?
int greaterThanOrEqualTo(unsigned int *numA, unsigned int *numB, int count) {
    int i, result;

    for (int i = count - 1; i >= 0; i--)
    {
        if(numA[i] > numB[i])
            return 1;
        else if (numA[i] < numB[i])
            return 0;
    }
    return 1;
}

void subtract(unsigned int *numA, unsigned int *numB, unsigned int *difference, int count) {
    
    difference = (unsigned int*) malloc(sizeof(unsigned int) * count);

    for (int i = 0; i < count; i++)
    {
        // TODO: Math
    }
}