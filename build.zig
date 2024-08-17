const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const extras = b.dependency("zig-extras", .{});
    const extras_module = extras.module("extras");

    const time_module = b.addModule("time", .{
        .optimize = optimize,
        .target = target,
        .imports = &.{.{ .name = "extras", .module = extras_module }},
    });

    const t = b.addTest(.{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("main.zig"),
    });
    t.root_module.addImport("time", time_module);

    const run_t = b.addRunArtifact(t);

    const t_step = b.step("test", "Run all the tests.");
    t_step.dependOn(&run_t.step);
}
