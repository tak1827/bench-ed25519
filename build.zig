const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("bench-ed25519", "src/main.zig");
    exe.addCSourceFile("ed25519-donna/ed25519.c", &[_][]const u8{"-std=c99"});
    exe.setBuildMode(mode);

    exe.addIncludeDir("ed25519-donna");

    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("openssl");
    exe.linkSystemLibrary("sodium");
    exe.install();

    const run_cmd = exe.run();

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    b.default_step.dependOn(&exe.step);
    b.installArtifact(exe);
}
