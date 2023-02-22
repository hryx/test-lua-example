const ziglua = @import("lua");
const Lua = ziglua.Lua;
const State = ziglua.State;

export fn luaopen_corncob(state: ?*State) c_int {
    const lua = Lua.fromState(state);
    lua.newLib(&.{
        .{ .name = "chomp", .func = chomp },
    });
    lua.pushValue(-1);
    lua.setMetatable(-2);
    return 1;
}

fn chomp(state: ?*State) callconv(.C) c_int {
    const lua = Lua.fromState(state);
    const num = lua.checkNumber(1);
    lua.pushNumber(num * 10);
    return 1;
}
