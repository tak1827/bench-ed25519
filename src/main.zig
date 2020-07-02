const std = @import("std");
const assert = @import("std").debug.assert;
const time = std.time;
const c = @cImport({
  @cInclude("ed25519.h");
  @cInclude("ed25519-donna.h");
});

const message = [_]u8{ 'h','e','l','l','o' };
var sk: c.ed25519_secret_key = [_]u8{ 'a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','a','b','c','d','e','1','2' };
var pk: c.ed25519_public_key = undefined;
var signature: c.ed25519_signature = undefined;

pub fn main() !void {
  c.ed25519_publickey(&sk, &pk);
  c.ed25519_sign(&message, 5, &sk, &pk, &signature);

  const benchtime = time.ns_per_s * 10; // 10s
  try bench("BenchmarkVerify", verifySig, benchtime, 10);
  try bench("BenchmarkVerify", verifySig, benchtime, 1000);
}

pub fn bench(comptime name: []const u8, F: var, benchtime: comptime_int, count: usize) !void {
  var timer = try time.Timer.start();

  var loops: usize = 0;
  while (timer.read() < benchtime) : (loops += 1) {
    _ = F(count);
  }

  const loopPerS = loops * time.ns_per_s / benchtime;
  const timePerOp = benchtime / loops;
  std.debug.warn("{}{}:   {} loops/s   {} ns/op\n", .{ name, count, loopPerS, timePerOp });
}

fn verifySig(n: usize) void {
  var i: usize = 0;
  while (i < n) {
    i += 1;
    const valid = c.ed25519_sign_open(&message, 5, &pk, &signature) == 0;
    // assert(valid);
  }
  // assert(i == n);
}
