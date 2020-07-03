#include <sodium.h>
#include <time.h>
#include <stdio.h>

#define MESSAGE (const unsigned char *) "test"
#define MESSAGE_LEN 4

unsigned char pk[crypto_sign_PUBLICKEYBYTES];
unsigned char sk[crypto_sign_SECRETKEYBYTES];
unsigned char sig[crypto_sign_BYTES];

int verify_sig(int n) {
  int i;
  while (i < n) {
    i += 1;
    if (crypto_sign_verify_detached(sig, MESSAGE, MESSAGE_LEN, pk) != 0) {
        printf("signature is wrong\n");
        return 1;
    }
  }
  return 0;
}

int bench(const unsigned char *name, double benchtime, int count) {
  // clock_t start_t, end_t, total_t;
  clock_t start_t = clock();

  int loops;
  while (clock() < start_t + benchtime) {
    if (verify_sig(count) > 0) {
      return 1;
    }
    loops += 1;
  }

  int loop_per_s = loops * CLOCKS_PER_SEC / benchtime;
  int time_per_op = benchtime / loops;
  printf("%s-%d:   %d   %d loops/s   %d ms/op\n", name, count, loops, loop_per_s, time_per_op);
  return 0;
}

int main(void) {
  if (sodium_init() < 0) {
    printf("sodium couldn't be initialized, it is not safe to use\n");
    return 1;
  }

  crypto_sign_keypair(pk, sk);
  crypto_sign_detached(sig, NULL, MESSAGE, MESSAGE_LEN, sk);

  double benchtime = 10 * CLOCKS_PER_SEC; // 10s
  if (bench("BenchmarkVerify-Sodium-C", benchtime, 10) > 0) {
    return 1;
  }

  return 0;
}
