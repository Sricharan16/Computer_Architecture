
#define N 700
#define NUM_BLOCKS 16
#define NUM_THREADS 48
//Do not change above three lines.

//Submission should be named as  <RollNumber>_Prog.cu
//Upload just this cu file and nothing else. If you upload it as a zip, it will$

/*Remember the following guidelines to avoid losing marks
This exercise is quite simple. The only tricky part is that total number of thr$

Index of an array should not exceed the array size.

No output array-element should be computed more than once

No marks will be given if the program does not compile or run (TAs will not deb$

Do not change the name of any variable that we have introduced.
*/

#include <stdio.h>
//TODO: WRITE GPU KERNEL. It should not be called repeatedly from the host, butA
__global__ void Add(int* A, int* B, int* C,int r){
           int i = blockDim.x*blockIdx.x+threadIdx.x+(r*NUM_THREADS*NUM_BLOCKS);

         if(i<N*N){
           C[i] = A[i] + B[i];
//          printf("%d\n",i);
      }
}

int main (int argc, char **argv) {
  int A[N][N], B[N][N], C[N][N];
  int *d_A, *d_B, *d_C; // These are the copies of A, B and C on the GPU
   int *h_C;       // This is a host copy of the output of B from the GPU
  int i, j;
  const size_t size = sizeof(int) * size_t(N*N);
  h_C = new int[size];
  for(i=0;i<N;i++) {
    for(j=0;j<N;j++) {
      A[i][j] = i+j;
      B[i][j]= 2*j-1;
    }
  }
  // sequential implementation of main computation
  for(i=0;i<N;i++) {
    for(j=0;j<N;j++) {
      C[i][j] = A[i][j]+B[i][j];
    }
  }

  // TODO: ALLOCATE MEMORY FOR GPU COPIES OF d_A, d_B and d_C
  cudaMalloc(&d_A, size);
  cudaMalloc(&d_B, size);
  cudaMalloc(&d_C, size);
  // TODO: COPY A TO d_A
  cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
  // TODO: COPY B TO d_B
  cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);
  // TODO: CREATE BLOCKS with THREADS AND INVOKE GPU KERNEL
   //Use NUM_BLOCKS blocks, each with NUM_THREADS  threads

int r;
if((N*N)%(NUM_BLOCKS*NUM_THREADS)==0){
  r=(N*N)/(NUM_BLOCKS*NUM_THREADS);
}
else{
  r=((N*N)/(NUM_BLOCKS*NUM_THREADS))+1;
}

  if((NUM_BLOCKS*NUM_THREADS)>=N*N){
  Add<<<NUM_BLOCKS,NUM_THREADS>>>(d_A,d_B,d_C,0);
}
else{
for (int i=0;i<r;i++){
   Add<<<NUM_BLOCKS,NUM_THREADS>>>(d_A,d_B,d_C,i);
}
}
  // TODO: COPY d_C BACK FROM GPU to CPU in variable h_C
  cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
  // TODO: Verify result is correct by comparing
  bool flags=0;
  for(i=0;i<N;i++) {
 for(j=0;j<N;j++) {
    //TODO: compare each element of h_C and C by subtracting them
//       printf("%d, %d\n",h_C[i*N+j],C[i][j]);
        //print only those elements for which the above subtraction is non-zero
      if(h_C[i*N+j]!=C[i][j])
        {
         flags=1;
        }
    }
   }
 //IF even one element of h_C and C differ, report an error.
    //Otherwise, there is no error.
    //If your program is correct, no error should occur.
   if(flags==1)
   {
    printf("ERROR in the program");
   }
   else
    printf("The program is working correctly");
  return 0;
}

