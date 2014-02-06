#define BLOCKDIM 32
#define ISGREATER 2
#define NOTGREATER 3
#define NOTSURE 1
#define NOTIFY_IS_GREATER 4
#define NOTIFY_NOT_GREATER 5

__global__ void 

__device__ void  shiftR(BigInt *n) {
   unsigned int part = n->elements[threadIdx.x];
   __shared__ unsigned int rsResult[BLOCKDIM][BLOCKDIM] = {{0}};
   unsigned int mask = 1;

   if(threadIdx.x != 0) {
      rsResult[threadIdx.y][threadIdx.x - 1] |= (part & mask) << 31;
   }

   part >>= 1;

   if(threadIdx.x != blockDim.x - 1) {
      rsResult[threadIdx.y][threadIdx.x] |= part;
   }
   __syncThreads();
   n->elements[threadIdx.x] = rsResult[threadIdx.y][threadIdx.x];
   __syncthreads();
}

__device__ void  shiftL(BigInt *n) {
   unsigned int part = n->elements[threadIdx.x];
   __shared__ unsigned int lOverflow[BLOCKDIM][BLOCKDIM];
   unsigned int mask = 1 << 31;

   if(threadIdx.x != blockDim.x - 1) {
      lOverflow.elements[threadIdx.y][threadIdx.x - 1] = (part & mask) >> 31;
   }

   part <<= 1;
   __syncthreads();

   if(threadIdx.x != 0)
      part = part | lOverflow.elements[threadIdx.y][threadIdx.x];
   }

   n->elements[threadIdx.x] = part;
   __syncthreads();
}

__device__ void cuSubtract(BigInt n, BigInt m, unsigned int *res) {

   unsigned int partn = n->elements[threadIdx.x];
   unsigned int partm = m->elements[threadIdx.x];
   unsigned int carry[BLOCKDIM][BLOCKDIM] = {{0}};
   __shared__ short okayToGo[BLOCKDIM][BLOCKDIM] = {{0}};
   unsigned int result = 0;
   unsigned int tmp;

   partm = ~partm;

   if(threadIdx.x == 0) {
      tmp = partm++;
      if(tmp < partm) {
         carry[threadIdx.y][threadIdx.x + 1] += 1;
      }
      partm = tmp;
   }

   res = partn + partm;
   if((res < partn || res < partm) && threadIdx.x < BLOCKDIM - 1) {
      carry[threadIdx.y][threadIdx.x + 1] += 1;
   }

   __syncthreads();

   if(threadIdx.x == 0) {
      okToGo[threadIdx.y][threadIdx.x] = 1;
   }

   while(!okToGo[threadIdx.y][threadIdx.x]) {};

   tmp = result + carry[threadIdx.y][threadIdx.x];
   if(tmp < result && threadIdx.x < BLOCKDIM - 1) {
      carry[threadIdx.y][threadIdx.x] += 1;
   }
   
   if(threadIdx < BLOCKDIM - 1) {
      okayToGo[threadIdx.y][threadIdx.x] = 1;
   }

   res[threadIdx.x] = tmp;

   __syncthreads();
}

__device__ bool geq(BigInt *n, BigInt *m) {

   /*keep a shared mem array that contains flags for thread actions*/
   __shared__ short gThan[BLOCKDIM][BLOCKDIM] = {{0}};
   short res;

   /*Set the Most significant thread to a val to start the process*/
   if(threadIdx.x == BLOCKDIM - 1) {
      gThan[threadIdx.y][threadIdx.x] = NOTSURE;
   }

   /*Loop the threads until a flag is set for them*/
   while(!gThan[threadIdx.y][threadIdx.x]){};

   res = gThan[threadIdx.y][threadIdx.x];

   /* If a more significant thread found out that the numbers
    * were greater, notify the less significant threads and
    * return.
    */
   if(res == ISGREATER) {
      /* The least significant thread doesn't need to
       * notify anyone.
       */
      if(threadIdx.x != 0) {
         gThan[threadIdx.y][threadIdx.x - 1] = ISGREATER;
      }

      return true;
   }

   /* If a more significant thread found out that the numbers
    * were not greater, notify the less significant threads and
    * return.
    */
   if(res == NOTGREATER) {
      /* The least significant thread doesn't need to
       * notify anyone.
       */
      if(threadIdx.x != 0) {
         gThan[threadIdx.y][threadIdx.x - 1] = ISGREATER;
      }

      return true;
   }

   /* If a more significant thread was unsure whether the
    * numbers were greater than or not, check the numbers
    * handled by THIS current thread.
    */
   if(res == NOTSURE) {
      /* If the numbers handled by this thread show n is greater
       * than m, then notify the more significant threads, and
       * the lesser significant threads, and return.
       */
      if(n->elements[threadIdx.x] > m->elements[threadIdx.x]) {
         if(threadIdx.x != BLOCKDIM - 1) {
            gThan[threadIdx.y][threadIdx.x + 1] = NOTIFY_IS_GREATER;
         }
         if(threadIdx.x != 0) {
            gThan[threadIdx.y][threadIdx.x - 1] = ISGREATER;
         }
         return true;
      }

      /* If the numbers handled by this thread show n is not greater
       * than m, then notify the more significant threads, and
       * the lesser significant threads, and return.
       */
      else if(n->elements[threadIdx.x] < m->elements[threadIdx.x]) {
         if(threadIdx.x != BLOCKDIM - 1) {
            gThan[threadIdx.y][threadIdx.x + 1] = NOTIFY_NOT_GREATER;
         }
         if(threadIdx.x != 0) {
            gThan[threadIdx.y][threadIdx.x - 1] = NOTGREATER;
         }
         return false;
      }

      /* If the numbers handled by this thread are equal ...*/
      else {
         /* If this thread is the least significant thread, 
          * notify all other threads and return.
          */
         if(threadIdx.x == 0) {
            gThan[threadIdx.y][threadIdx.x + 1] = NOTIFY_IS_GREATER;
            return true;
         }
         
         /* If the number is not the least significant thread,
          * tell the next less significant thread it is unsure.
          */
         gThan[threadIdx.y][threadIdx.x - 1] = NOTSURE;

      }
   } 

   res = gThan[threadIdx.y][threadIdx.x];
   
   /* Wait for the lesser significant threads to notify this
    * thread of an answer if it was unsure.
    */
   while(res != NOTIFY_IS_GREATER || res != NOTIFY_NOT_GREATER) {
      res = gThan[threadIdx.y][threadIdx.x];
   }

   if(res == NOTIFY_IS_GREATER) {
      gThan[threadIdx.y][threadIdx.x + 1] = NOTIFY_IS_GREATER;
      return true;
   }
   
   gThan[threadIdx.y][threadIdx.x + 1] = NOTIFY_NOT_GREATER;
   return false;
}
   
__device__ BigInt gcd(BigInt n, BigInt m) {

   int i;
   unsigned int tmp;

   for(i = 0; ((n.elements[0] | m.elements[0]) & 1) == 0; i++) {
      shiftR(&n);
      shiftR(&m);
   }

   while ((n.elements[0] & 1) == 0) {
      __syncthreads();
      shiftR(&n);
   }

   do {
      while((m.elements[0] & 1) == 0) {
         __syncthreads();
         shiftR(&m);
      }

      if(geq(&n, &m)) {
         tmp = n.elements[threadIdx.x];
         n.elements[threadIdx.x] = m.elements[threadIdx.x];
         m.elements[threadIdx.x] = tmp;
      }
      __syncthreads();

      cuSub(n, m);
   } while(
















