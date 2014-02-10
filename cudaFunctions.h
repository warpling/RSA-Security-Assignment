#include <stdint.h>
#define BLOCKDIM_X 32
#define BLOCKDIM_Y 1
#define ISGREATER 2
#define NOTGREATER 3
#define NOTSURE 1
#define NOTIFY_IS_GREATER 4
#define NOTIFY_NOT_GREATER 5

/*typedef struct bigInt{
    uint32_t *components;
} bigInt;*/

//__global__ void subTest(bigInt *key1, bigInt *key2, bigInt *result);
__global__ void gcdKernel(int base, int offset, bigInt *keys, int numKeys, uint32_t *results);
__device__ void  shiftR(uint32_t *n);
__device__ void  shiftL(uint32_t *n);
__device__ void cuSubtract(uint32_t *n, uint32_t *m);
__device__ bool geq(uint32_t *n, uint32_t *m);
__device__ bool notOne(uint32_t *n);
__device__ bool notZero(uint32_t *n);
__device__ uint32_t* gcd(uint32_t *n, uint32_t *m);
