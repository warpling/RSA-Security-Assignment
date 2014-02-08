#define BLOCKDIM_X 32
#define BLOCKDIM_Y 8
#define ISGREATER 2
#define NOTGREATER 3
#define NOTSURE 1
#define NOTIFY_IS_GREATER 4
#define NOTIFY_NOT_GREATER 5

typedef struct BigInt{
   unsigned int components[32];
}BigInt;

__global__ void gcdKernel(int base, int offset, BigInt keys[], int numKeys, char results[]);
__device__ void  shiftR(BigInt *n);
__device__ void  shiftL(BigInt *n);
__device__ void cuSubtract(BigInt n, BigInt m);
__device__ bool geq(BigInt *n, BigInt *m);
__device__ bool notOne(BigInt n);
__device__ bool notZero(BigInt n);
__device__ BigInt gcd(BigInt *n, BigInt *m);
