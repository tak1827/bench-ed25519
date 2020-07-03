#include <stdio.h>
#include "../ed25519-donna/ed25519.h"
#include "../ed25519-donna/ed25519-donna.h"

int main(void) {

  const unsigned char message[] = "hello";
  ed25519_secret_key sk = "abcdeabcdeabcdeabcdeabcdeabcde12";
  ed25519_public_key pk;
  ed25519_signature sig;

  ed25519_publickey(sk, pk);
  ed25519_sign(message, sizeof(message), sk, pk, sig);

  if (ed25519_sign_open(message, sizeof(message), pk, sig) == 0) {
    printf("signature is collect\n");
  } else {
    printf("signature is wrong\n");
    return 1;
  }

  return 0;
}
