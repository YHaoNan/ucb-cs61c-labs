#include <stdio.h>
#include "bit_ops.h"

/* Returns the Nth bit of X. Assumes 0 <= N <= 31. */
unsigned get_bit(unsigned x, unsigned n) {
  return (x>>n) & 0x1;
}

/* Set the nth bit of the value of x to v. Assumes 0 <= N <= 31, and V is 0 or 1 */
void set_bit(unsigned *x, unsigned n, unsigned v) {
  // 使用逻辑或可以不用ifelse，但是产出的代码很丑
  if (!v) {
    *x &= ~(1<<n);
  } else {
    *x |= (1<<n);
  }
}

/* Flips the Nth bit in X. Assumes 0 <= N <= 31.*/
void flip_bit(unsigned *x, unsigned n) {
  if (get_bit(*x, n)) set_bit(x, n, 0);
  else set_bit(x, n, 1);
}

