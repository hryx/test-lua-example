const std = @import("std");

pub fn build(b: *std.Build) void {
    b.addModule(.{
        .name = "lua",
        .source_file = .{ .path = "lua/lua.zig" },
    });
}
