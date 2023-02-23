const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lua_dep = b.dependency("lua", .{
        .target = target,
        .optimize = optimize,
    });
    const lib = b.addSharedLibrary(.{
        .name = "corncob",
        .root_source_file = .{ .path = "src/corncob.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.addModule("lua", lua_dep.module("lua"));
    // The module uses cImport, but there is no way to add include path to a module,
    // so we have to add the include path to the lib which uses the module.
    // The path is relative to the locally cached version of the package.
    const path = b.global_cache_root.join(b.allocator, &.{
        "p",
        "122055c92fa2b54a9d244645687f4675efcbf95129f90d97ff646d6f878844472888",
        "lua",
        "include",
    }) catch unreachable;
    lib.addIncludePath(path);
    // Symbols resolved at load time by Lua
    lib.linker_allow_shlib_undefined = true;
    lib.install();
}
