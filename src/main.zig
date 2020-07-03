const std = @import("std");
const assert = @import("std").debug.assert;
const time = std.time;
const c = @cImport({
  @cInclude("ed25519.h");
  @cInclude("ed25519-donna.h");
  // @cInclude("sodium.h");
});

const message = [_]u8{ 'h','e','l','l','o' };

// ed25519-donna
var skEd25519: c.ed25519_secret_key = [_]u8{ 'a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','1','2' };
var pkEd25519: c.ed25519_public_key = undefined;
var sigEd25519: c.ed25519_signature = undefined;

// sodium
var skSodium: [c.crypto_sign_SECRETKEYBYTES]u8 = undefined;
var pkSodium: [c.crypto_sign_PUBLICKEYBYTES]u8 = undefined;
var sigSodium: [c.crypto_sign_BYTES]u8 = undefined;

pub fn main() !void {

  // bench of ed25519-donna
  c.ed25519_publickey(&skEd25519, &pkEd25519);
  c.ed25519_sign(&message, 5, &skEd25519, &pkEd25519, &sigEd25519);

  const benchtime = time.ns_per_s * 10; // 10s
  try bench("BenchmarkVerify-Donna-Zig", verifySigEd25519, benchtime, 10);
  try bench("BenchmarkVerify-Donna-Zig", verifySigEd25519, benchtime, 1000);

  // if (c.sodium_init() < 0) {
  //    std.debug.panic("sodium couldn't be initialized, it is not safe to use\n", .{});
  // }

  // // bench of sodium
  // _ = c.crypto_sign_keypair(&pkSodium, &skSodium);
  // _ = c.crypto_sign_detached(&sigSodium, null, &message, 5, &skSodium);

  // if (c.crypto_sign_verify_detached(&sigSodium, &message, 5, &skSodium) != 0) {
  //   std.debug.warn("Hello, world!\n", .{});
  // }
}

pub fn bench(comptime name: []const u8, F: var, benchtime: comptime_int, count: usize) !void {
  var timer = try time.Timer.start();

  var loops: usize = 0;
  while (timer.read() < benchtime) : (loops += 1) {
    _ = F(count);
  }

  const loopPerS = loops * time.ns_per_s / benchtime;
  const timePerOp = benchtime / loops;
  std.debug.warn("{}-{}:   {}   {} loops/s   {} ns/op\n", .{ name, count, loops, loopPerS, timePerOp });
}

fn verifySigEd25519(n: usize) void {
  var i: usize = 0;
  while (i < n) {
    i += 1;
    const valid = c.ed25519_sign_open(&message, 5, &pkEd25519, &sigEd25519) == 0;
    // assert(valid);
  }
  // assert(i == n);
}
