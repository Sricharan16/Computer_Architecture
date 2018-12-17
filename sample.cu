#include <stdio.h>
#include <stdlib.h>

#define N 512
#define threads 48
__global__ void MatAdd(int* A, int* B, int* C){
           int i = blockDim.x*blockIdx.x+threadIdx.x;
            int j = blockDim.y*blockIdx.y+threadIdx.y;
            int idx=i*N+j;
           // if((idx<N*N) && i<N && j<N)
           C[idx] = A[idx] + B[idx];
       }


int main(){

int A[N][N];
int B[N][N];
int C[N][N];
const size_t size = sizeof(int) * size_t(N*N);
int (*pA), (*pB), (*pC);
int *h_C;
cudaMalloc(&pA, size);
cudaMalloc(&pB, size);
cudaMalloc(&pC, size);
h_C= new int[size];
for(int i=0;i<N;i++)
{
for(int j=0;j<N;j++)
{
A[i][j]=i+j;
B[i][j]=2*j-1;

C[i][j]=A[i][j]+B[i][j];
}
}
cudaMemcpy(pA, A, size, cudaMemcpyHostToDevice);
cudaMemcpy(pB, B, size, cudaMemcpyHostToDevice);
cudaMemcpy(pC, C, size, cudaMemcpyHostToDevice);

dim3 threadsPerBlock(threads,threads);
dim3 numOfBlocks(N/threads,N/threads);
MatAdd<<<numOfBlocks,threadsPerBlock>>>(pA,pB,pC);

cudaMemcpy(h_C, pC, size, cudaMemcpyDeviceToHost);

int i, j; printf("C = \n");
for(i=0;i<N;i++){
    for(j=0;j<N;j++){
        printf("%d ", h_C[i*N+j]);
        if(h_C[i*N+j]!=C[i][j])
        {
                printf("ERROR\n");
                exit(0);
        }
        if(i==N-1 && j==N-1)
                printf("running perfectly\n");
    }
    printf("\n");
}

cudaFree(pA);
cudaFree(pB);
cudaFree(pC);

printf("\n");
        return 0;
}



