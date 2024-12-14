const std = @import("std");

pub fn build(b: *std.Build) void {
    // const optopt = b.standardOptimizeOption(.{});
    const optimize = .ReleaseFast;
    const target = b.standardTargetOptions(.{});

    const raylib_dep = b.dependency("raylib", .{ .target = target, .optimize = optimize });
    const raylib = raylib_dep.artifact("raylib");
    b.installArtifact(raylib);

    const exe = b.addExecutable(.{
        .name = "protractor",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    exe.root_module.addImport("raylib", &raylib.root_module);
    exe.root_module.addAnonymousImport("resources/protractor.png", .{ .root_source_file = b.path("resources/protractor.png") });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
