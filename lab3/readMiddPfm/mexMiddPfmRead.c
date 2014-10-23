#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include "mex.h"

union Float {
  float val;
  unsigned char bytes[4];
};

void readMiddPfm(const mxArray *p, mxArray **out) {
  char fn[500];
  int err = mxGetString(p, fn, 500);
  if (err) {
    mexErrMsgTxt("Input should be file name\n");
  }
  err = (int) freopen(fn, "r", stdin);
  if (!err) {
    mexErrMsgTxt("Wrong file name\n");
  }
  char buffer[20];
  scanf("%s", buffer);
  int cols, rows;
  scanf("%d%d", &cols, &rows);
  double scale;
  scanf("%lf", &scale);
  // get rid of trailing white space
  getchar();
  //*cp = cols;
  //*rp = rows;
  mxArray *vals = mxCreateDoubleMatrix(rows, cols, mxREAL);
  *out = vals;
  union Float tmp;
  int i, j;
  double *ptr = mxGetPr(vals);
  for (i = rows - 1; i >= 0; i--) {
    for (j = cols - 1; j >= 0; j--) {
      int k;
      for (k = 0; k < 4; k++) {
        tmp.bytes[k] = getchar();
      }
      ptr[j*rows + i] = tmp.val;
    }
  }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  assert(nrhs == 1);
  readMiddPfm(prhs[0], &plhs[0]);
}