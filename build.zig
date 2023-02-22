const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Uses cImport, but no way to add include path to a module...
    b.addModule(.{
        .name = "lua",
        .source_file = .{ .path = "lua/lua.zig" },
    });
    const lib = b.addSharedLibrary(.{
        .name = "corncob",
        .root_source_file = .{ .path = "src/corncob.zig" },
        .target = target,
        .optimize = optimize,
    });
    // ...so we have to add the include path to the lib which uses the module
    lib.addIncludePath("lua/include");
    lib.addModule("lua", b.modules.get("lua").?);
    // Symbols resolved at load time by Lua
    lib.linker_allow_shlib_undefined = true;
    lib.install();
}
