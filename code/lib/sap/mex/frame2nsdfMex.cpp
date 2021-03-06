// Frame 2 NSDF
// How to compile:
// MATLAB 7.1: mex frame2nsdfMex.cpp d:/users/jang/c/lib/audio.cpp d:/users/jang/c/lib/utility.cpp -output frame2nsdfMex.dll
// Others: mex frame2nsdfMex.cpp d:/users/jang/c/lib/audio.cpp d:/users/jang/c/lib/utility.cpp
#include <string.h>
#include <math.h>
#include "mex.h"
#include "audio.hpp"

/* Input Arguments */
#define	FRAME		prhs[0]
#define	MAXSHIFT	prhs[1]
#define	METHOD		prhs[2]

/* Output Arguments */
#define	OUTPUT	plhs[0]

void mexFunction(
	int nlhs,	mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
	double *frame, *output;
	int i, frameSize, maxShift, method;

	/* Check for proper number of arguments */
	if (nrhs<1) {
		char message[200];
		strcpy(message, mexFunctionName());
		strcat(message, " requires 1 input arguments.\n");
		strcat(message, "Usage: output = ");
		strcat(message, mexFunctionName());
		strcat(message, "(frame, method)\n");
		strcat(message, "\tThis function is synchronized with frame2nsdf.m.\n");
		mexErrMsgTxt(message);
	}
	
	/* Assign pointers to the various parameters */
	frame = mxGetPr(FRAME);
	frameSize = mxGetM(FRAME)*mxGetN(FRAME);
	maxShift=frameSize;
	method=1;
	if (nrhs>=2)
		maxShift=mxGetScalar(MAXSHIFT);
	if (nrhs>=3)
		method=mxGetScalar(METHOD);

	/* Create a matrix for the return argument */
	OUTPUT = mxCreateDoubleMatrix(maxShift, 1, mxREAL);
	output = mxGetPr(OUTPUT);
	/* Do the actual computation */
	frame2nsdf(frame, frameSize, output, maxShift, method);
}
