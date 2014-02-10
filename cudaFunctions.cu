#include "bigInt.h"
#include "cudaFunctions.h"

/*__global__ void subTest(bigInt *key1, bigInt *key2, bigInt *result) {
   int i;
   uint32_t *ptr;
   uint32_t *keyptr1, *keyptr2;
   __shared__ uint32_t keyComp1[BLOCKDIM_X];
   __shared__ uint32_t keyComp2[BLOCKDIM_X];
   keyComp1[threadIdx.x] = key1->components[threadIdx.x];
   keyComp2[threadIdx.x] = key2->components[threadIdx.x];
   keyptr1 = keyComp1;
   keyptr2 = keyComp2;
   printf("here!\n");

   ptr = gcd(keyptr1, keyptr2);
   result->components[threadIdx.x] = ptr[threadIdx.x];
   if(threadIdx.x == 0) {
      printf("gcd = %d\n", result->components[threadIdx.x]);
   }
   //for(i = 0; i < 156; i ++) {
      //shiftL(key1.components);
   //}
   
   //cuSubtract(key1.components, key2.components);
   /*if(geq(&key1, &key2)) {
      result.components[threadIdx.x] = 1;
   }
   else {
      result.components[threadIdx.x] = 0;
   }
   //result.components[threadIdx.x] = key1.components[threadIdx.x];
} */

__global__ void gcdKernel(int base, int offset, bigInt *keys, int numKeys, uint32_t *results) {
   
   int key1 = base;
   int key2 = offset + blockIdx.x;
   uint32_t mask = (uint32_t)(1 << 31);
   uint32_t *keyptr1, *keyptr2;
   __shared__ uint32_t sharedkey1[BLOCKDIM_X];
   __shared__ uint32_t sharedkey2[BLOCKDIM_X];
   uint32_t *res;
   
   
   if(key1 < key2 && key2 < numKeys && key1 < numKeys) {
      sharedkey1[threadIdx.x] = keys[key1].components[threadIdx.x];
      sharedkey2[threadIdx.x] = keys[key2].components[threadIdx.x];
      __syncthreads();
      keyptr1 = sharedkey1;
      keyptr2 = sharedkey2;
      res = gcd(keyptr1, keyptr2);
      if(notOne(res)) {
         atomicOr(results + (key1/32), mask >> (key1%32));
         atomicOr(results + (key2/32), mask >> (key2%32));
         /*if(threadIdx.x == 0) {
            //printf("found bad key!, gcd = %d, key1: %d, key2: %d\n", res[threadIdx.x], key1, key2);
         }*/
      }
   }
}

__device__ void  shiftR(uint32_t *n) {
   uint32_t part = 0;
   uint32_t tmp;
   int id = threadIdx.x;

   if(id != 31) {
      part = n[threadIdx.x + 1];
   }
   tmp = (n[threadIdx.x] >> 1) | (part << 31);
   n[threadIdx.x] = tmp;
}

__device__ void  shiftL(uint32_t *n) {
   uint32_t part = 0;

   if(threadIdx.x) {
      part = n[threadIdx.x - 1];
   }
   n[threadIdx.x] = (n[threadIdx.x] << 1) | (part >> 31);
}

__device__ void cuSubtract(uint32_t *n, uint32_t *m) {
   uint32_t partn = n[threadIdx.x];
   uint32_t partm = m[threadIdx.x];
   uint32_t tmp;
   int carry;

   n[threadIdx.x] = partn - partm;
   tmp = n[threadIdx.x];
   if(threadIdx.x != 31) {
      carry = tmp > partn;
   }
   partn = tmp;
   
   while(__any(carry)) {
      if(threadIdx.x == 31) {
         carry = 0;
      }
      else if(carry) {
         n[threadIdx.x + 1] --;
         carry = 0;
      }
      if(n[threadIdx.x] > tmp && threadIdx.x != 31) {
         carry = 1;
      }
      tmp = n[threadIdx.x];
   }
   n[threadIdx.x] = tmp;
}

__device__ bool geq(uint32_t *n, uint32_t *m) {

   __shared__ int differPos[BLOCKDIM_Y];
   int *pos = differPos + threadIdx.y;

   if(threadIdx.x == 0) {
      differPos[threadIdx.y] = 0;
   }

   if(n[threadIdx.x] != m[threadIdx.x]) {
      atomicMax(pos, threadIdx.x);
   }

   return n[*pos] >= m[*pos];
}
 
__device__ bool notOne(uint32_t *n) {
   int ind = threadIdx.x;
   int res = 0;

   if(ind != 0 && n[ind] != 0) {
      res = 1;
      
   }
   if(ind == 0 && n[ind] != 1) {
      res = 1;
   }
   if(__any(res)) {
      res = 1;
   }

   return res;
}

__device__ bool notZero(uint32_t *n) {

   if(__any(n[threadIdx.x])) {
      return true;
   }
   return false;
}

__device__ uint32_t* gcd(uint32_t *n, uint32_t *m) {

   int i;
   uint32_t tmp;
   uint32_t *tmpptr;

   for(i = 0; ((n[0] | m[0]) & 1) == 0; i++) {
      shiftR(n);
      shiftR(m);
   }

   tmp = n[0];

   while ((tmp & 1) == 0) {
      shiftR(n);
      tmp = n[0];
   }

   do {
      while((m[0] & 1) == 0) {
         shiftR(m);
      }

      if(geq(n, m)) {
         tmpptr = n;
         n = m;
         m = tmpptr;
      }

      cuSubtract(m, n);
   } while(notZero(m));
   while(i != 0) {
      shiftL(n);
      i--;
   }
   return n;
}

