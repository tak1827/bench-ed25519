# bench-ed25519
Benchmarking of ed25519 by zig using `floodyberry-ed25519-donna` and `jedisct1/libsodium`.

# Result
```
root@3c714e28acef:~/Documents/hyperia/working/bench-ed25519# ./zig-cache/bin/ed25519-donna-bench
BenchmarkVerify10:   1886 loops/s   530054 ns/op
BenchmarkVerify1000:   19 loops/s   52083333 ns/op
```
