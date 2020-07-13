# bench-ed25519
Benchmarking of ed25519 by zig using `floodyberry-ed25519-donna` and `jedisct1/libsodium`.

# Install
```
# download ed25519-donna
git clone git@github.com:floodyberry/ed25519-donna.git ed25519-donna

# install libsodium
wget wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.17.tar.gz
tar xvf libsodium-1.0.17.tar.gz
cd libsodium-stable
./configure
make && make check
sudo make install
ldconfig
```

# Results
## ed25519-donna-bench by zig
```
~/bench-ed25519# ./zig-cache/bin/bench-ed25519
BenchmarkVerify-Donna-Zig-10:   18982   1898 loops/s   526814 ns/op
BenchmarkVerify-Donna-Zig-1000:   193   19 loops/s   51813471 ns/op
```

## ed25519-donna-bench by C
```
gcc -o ./clang/donna-bench ./clang/donna-bench.c -lssl -lcrypto
```

## sodium by C
```
~/bench-ed25519# gcc -o ./clang/sodium-bench ./clang/sodium-bench.c -lsodium
~/bench-ed25519# ./clang/sodium-bench
BenchmarkVerify-Sodium-C-10:   16234   1623 loops/s   615 ms/op
```
