#define char16_t UINT16_T

#include "mex.h"
#include "math.h"
#include <stdio.h>


void aX_plus_b(float *OUT, float *X, int m, int n, float a, float b) {
    
    // compute aX + b
    for(int i=0; i<m*n; i++) {
        // printf("a=%f, b=%f, X[%d]=%f\n",a,b,i,X[i]);
        OUT[i]= (float) (a*X[i] + b);
    }
}



//Y = mex_test(single(X),a,b);
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Get first argument into variable 'X'
    float* X;
    X = (float *)mxGetPr(prhs[0]);
    int m = mxGetM(prhs[0]);      // prhs[0] is a matrix representation
    int n = mxGetN(prhs[0]);
    
    
    // Get 2nd and 3rd input arguments
    float a = (float)mxGetScalar(prhs[1]);
    float b = (float)mxGetScalar(prhs[2]);
    
    
    // print the input information
    printf("  : size of A is %dx%d, a=%f, b=%f\n", m, n, a, b);
    
    
    // Create to temporally save a result
    float *Y_temp;
    Y_temp = new float[(int) m*n];
    for (int i=0; i<m*n; i++) Y_temp[i]=0.0f;
    
    
    // Compute the aX + b
    aX_plus_b(Y_temp, X, m, n, a, b);
    
    
    // Mapping computed results into a matrix
    double *Y;
    Y = (double*)mxGetData(plhs[0]=mxCreateDoubleMatrix(m,n,mxREAL));
    for (int i=0; i<m*n; i++)
        Y[i] = (double)Y_temp[i];
    
    delete [] Y_temp;
}
