#include "bigInt.h"
#include "cuda.h"
#include "cuda_runtime_api.h"
#include "cudaFunctions.h"
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>

#define MODULI_BUF_SIZE 2000
#define MAX_LENGTH_OF_1024_BIT_NUM 311

static void HandleError( cudaError_t err,
                         const char *file,
                         int line ) {
    if (err != cudaSuccess) {
        printf( "%s in %s at line %d\n", cudaGetErrorString( err ),
                file, line );
        exit( EXIT_FAILURE );
    }
}
#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))

/* This function opens a file, and maps all of its contents
 * to memory. It returns the pointer to this mapping.
 */
char *getFileContents(char* filename, size_t *len) {
   char *fileMapping;
   int file = open(filename, O_RDONLY);
   struct stat filestats;
   
   /*Check if file exists to grab contents*/
   if (file < 0) {
      printf("Error: %s does not exist or can't be read\n", filename);
      exit(EXIT_FAILURE);
   }
   
   /*Make sure that the stats retrieved by the file are valid*/
   if(fstat(file, &filestats) < 0) {
      printf("Error: stats could not be read by %s\n", filename);
      exit(EXIT_FAILURE);
   }
   
   /*Create the file mapping and return the result*/
   fileMapping = (char *) mmap(0, filestats.st_size, PROT_READ|PROT_WRITE, MAP_PRIVATE, file, 0);
   *len = filestats.st_size;
   
   if(close(file) < 0) {
      printf("Error: could not close %s after mapping.\n", filename);
      exit(EXIT_FAILURE);
   }
   
   return fileMapping;

}

/* This function goes through a mapping of a file
 * to compute the number of rows and columns of
 * the matrix represented in the mapping.
 */
void getFileStats(char *file, int *numKeys) {
   char *saved;
   /*Newlines represent rows*/
   char* sep1 = "\n";
   *numKeys = 0;

   /*Parse the mapping until all rows are counted*/
   strtok_r(file, sep1, &saved);
   (*numKeys)++;

   while(strtok_r(NULL, sep1, &saved)) {
      (*numKeys)++;
   }
}


int main(int argc, char *argv[])
{
   bigInt *moduli;
   bigInt newBigInt;
   bigInt *cuModuli;
   //dim3 dimBlock(32, 1);
   dim3 dimGrid(1);
   char* file;
   FILE *fp;
   uint32_t *bitVec;
   uint32_t *cuBitVec;
   size_t len;
   int i = 0, j;
   int numKeys = 0;
   uint32_t mask;
   int count = 0;
   dim3 dimBlock(32, 1);
   bigInt *num1;
   bigInt *num2;
   bigInt *cuNum1;
   bigInt *cuNum2;
   bigInt *cuSubRes;
   bigInt *subRes;

   if(argc < 2) {
        fprintf(stderr, "Usage: %s <file name>\n", argv[0]);
        return -1;
    }

    file = getFileContents(argv[1], &len);
      
    /* Check the validity of the mappings from both
     * files.
     */
    if (file == MAP_FAILED) {
      printf("Error: invalid map to one or more files\n");
      exit(EXIT_FAILURE);
    }
    getFileStats(file, &numKeys);
    munmap(file, len);
    printf("numkeys: %d\n", numKeys);
    moduli = (bigInt*) malloc(numKeys*sizeof(bigInt));
    bitVec = (uint32_t*) malloc(ceil(numKeys/32.0)*sizeof(uint32_t));

    bigInt *moduli = (bigInt*) malloc(MODULI_BUF_SIZE * sizeof(bigInt**));

    // Read in the bigInts
    int numModuli = readBigIntsFromFile(argv[1], moduli);

    if(numModuli < 0) {
        fprintf(stderr, "No moduli read. Exiting.\n");
        return -1;
    }

    printf("%d moduli read in.\n", numModuli);

    // send array to CUDA
    // -------------------------------------------------------------------------
    /*cudaMalloc((void **) &cuModuli, numKeys*sizeof(bigInt));
    cudaMemcpy((void *) cuModuli, (void *) moduli, numKeys*sizeof(bigInt), cudaMemcpyHostToDevice);
    cudaMalloc((void **) &cuBitVec, ceil(numKeys/32.0)*sizeof(uint32_t));
    cudaMemset((void *) cuBitVec, 0, ceil(numKeys/32.0)*sizeof(uint32_t)); */ 
    /*//for(i = 0; i < numKeys; i++) {
       //for(j = i + 1; j < numKeys; j++) {
         gcdKernel<<<dimGrid, dimBlock>>>(64, 66, cuModuli, numKeys, cuBitVec);
      //}
    //}
    cudaMemcpy((void *) bitVec, (void *) cuBitVec, ceil(numKeys/32.0)*sizeof(uint32_t), cudaMemcpyDeviceToHost);
    
    for(i = 0; i < ceil(numKeys/32.0); i++) {
       mask = 1;
       for(j = 0; j < 32; j++) {
          if(bitVec[i] & (mask << j)) {
             count ++;
          }
       }
    }
    printf("numBadKeys: %d\n", count);*/

    //num1.components = (uint32_t *) malloc(32*sizeof(uint32_t));
    //num2.components = (uint32_t *) malloc(32*sizeof(uint32_t));
    //subRes.components = (uint32_t *) malloc(32*sizeof(uint32_t));
    //for(i = 0; i < 32; i++) {
      // subRes.components[i] = 0;
    //}
    num1 = (bigInt *) malloc(sizeof(bigInt));
    num2 = (bigInt *) malloc(sizeof(bigInt));
    subRes = (bigInt *) malloc(sizeof(bigInt));
    num1->components[0] = 30;
    num2->components[0] = 5;

    for(i = 1; i < 32; i++) {
       num1->components[i] = 0;
       num2->components[i] = 0;
    }
    //num1.components[31] = 45;
    //num2.components[31] = 44;
    //num1.components[1] = 33;
    //num2.components[1] = 33;
    //num1.components[31] = 45;
    //num2.components[31] = 45;
    //num1.components[30] = 0;
    //num1.components[29] = 0;
    //num2.components[0] = ;
    cudaMalloc((void **) &cuNum1, sizeof(bigInt));
    cudaMalloc((void **) &cuNum2, sizeof(bigInt));
    cudaMalloc((void **) &cuSubRes, sizeof(bigInt));
    //cudaMemset((void *) cuSubRes.components, 0, 32*sizeof(uint32_t));
    cudaMemcpy((void *) cuNum1, (void *) num1, sizeof(bigInt), cudaMemcpyHostToDevice);
    cudaMemcpy((void *) cuNum2, (void *) num2, sizeof(bigInt), cudaMemcpyHostToDevice);
    subTest<<<1, dimBlock>>>(cuNum1, cuNum2, cuSubRes);
    HANDLE_ERROR(cudaMemcpy((void *) subRes, (void *) cuSubRes, sizeof(bigInt), cudaMemcpyDeviceToHost));

    for(i = 31; i >=0; i--) {
       printf("%u ", subRes->components[i]);
    }
    printf("\n");

    // get back bit array
    // -------------------------------------------------------------------------

    // calculate and print results
    // -------------------------------------------------------------------------

    return 0;
}
