#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <complex.h>
#define Space 256


int Log2(int N)    
{
  int k = N, i = 0;
  while(k) {
    k >>= 1;
    i++;
  }
  return i - 1;
}

int reverse(int N, int n)    //calculating reverse number
{
  int j, p = 0;
  for(j = 1; j <= Log2(N); j++) {
    if(n & (1 << (Log2(N) - j)))
      p |= 1 << (j - 1);
  }
  return p;
}

void ordina(float complex* f1, int N) //using the reverse order in the array
{
  float complex f2[Space];
  for(int i = 0; i < N; i++)
    f2[i] = f1[reverse(N, i)];
  
  for(int j = 0; j < N; j++)
    f1[j] = f2[j];
}

void transform(float complex* f, int N) //
{
  ordina(f, N);    //first: reverse order
  float complex *W;
  W = (float complex *)malloc(N / 2 * sizeof(float complex));
  //W[1] = polar(1., -2. * M_PI / N);
  W[1] = 1.0 + (-2. * 3.14 / N)*I;
  W[0] = 1;
  for(int i = 2; i < N / 2; i++){
      
      W[i] = cpow(W[1], i);
  }
  
  int n = 1;
  int a = N / 2;
  for(int j = 0; j < Log2(N); j++) {
    for(int i = 0; i < N; i++) {
      if(!(i & n)) {
        float complex temp = f[i];
        float complex Temp = W[(i * a) % (n * a)] * f[i + n];
        f[i] = temp + Temp;
        f[i + n] = temp - Temp;
      }
    }
    n *= 2;
    a = a / 2;
  }
}

int fft(int* f)
{
  
  float complex vec[Space];
  
  
  for (int i = 0; i < Space; i++){
	  vec[i] = (float)f[i] + 0*I;
  }
  
  transform(vec, Space);
  /*
  printf("...printing the FFT of the array specified\n");
  for (int i = 0; i < 2; i++){
      printf("%f, %f\n", creal(vec[i]), cimag(vec[i]));
  }
   */
   
   double sum[6];
   double largest = 0;
   int ultimate_index = 0;
   
   sum[0] = creal(vec[0])*creal(vec[0]) + cimag(vec[0])*cimag(vec[0]);
   largest = sum[0];
   ultimate_index = 0;
   
   for (int i = 1; i < 6; i ++){
	   sum[i] = creal(vec[i])*creal(vec[i]) + cimag(vec[i])*cimag(vec[i]);
	   
	   if(sum[i]>largest){
		   largest = sum[i];
		   ultimate_index = i;
	   }
	   
   }
  
  /*
  double sum[6];
  sum[0] = creal(vec[0])*creal(vec[0]) + cimag(vec[0])*cimag(vec[0]);
  sum[0] = sum[0] + creal(vec[1])*creal(vec[1]) + cimag(vec[1])*cimag(vec[1]);
  sum[1] = creal(vec[2])*creal(vec[2]) + cimag(vec[2])*cimag(vec[2]);
  sum[1] = sum[1] + creal(vec[3])*creal(vec[3]) + cimag(vec[3])*cimag(vec[3]);
  sum[2] = creal(vec[4])*creal(vec[4]) + cimag(vec[4])*cimag(vec[4]);
  sum[2] = sum[2] + creal(vec[5])*creal(vec[5]) + cimag(vec[5])*cimag(vec[5]);
  sum[3] = creal(vec[6])*creal(vec[6]) + cimag(vec[6])*cimag(vec[6]);
  sum[3] = sum[3] + creal(vec[7])*creal(vec[7]) + cimag(vec[7])*cimag(vec[7]);
  sum[4] = creal(vec[8])*creal(vec[8]) + cimag(vec[8])*cimag(vec[8]);
  sum[4] = sum[4] + creal(vec[9])*creal(vec[9]) + cimag(vec[9])*cimag(vec[9]);
  sum[5] = creal(vec[10])*creal(vec[10]) + cimag(vec[10])*cimag(vec[10]);
  sum[5] = sum[5] + creal(vec[11])*creal(vec[11]) + cimag(vec[11])*cimag(vec[11]);
  
  double largest = 0;
  int ultimate_index = 0;
   
   
   largest = sum[0];
   ultimate_index = 0;
   
   for (int i = 1; i < 6; i ++){
	   
	   
	   if(sum[i]>largest){
		   largest = sum[i];
		   ultimate_index = i;
	   }
	   
   }
  */
  return ultimate_index;
}