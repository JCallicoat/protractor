const std = @import("std");

pub fn build(b: *std.Build) void {
    // const optopt = b.standardOptimizeOption(.{});
    const optimize = .ReleaseFast;
    const target = b.standardTargetOptions(.{});

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
        .shared = true,
    });

    const raylib = raylib_dep.module("raylib"); // main raylib module
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library

    const exe = b.addExecutable(.{
        .name = "protractor",
        .root_module = b.createModule(.{ .root_source_file = b.path("src/main.zig"), .target = target, .optimize = optimize, .pic = true }),
        //.use_lld = false,
    });
    exe.pie = true;

    exe.linkLibC();
    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
