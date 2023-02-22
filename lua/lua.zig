pub const State = c.lua_State;

pub const Lua = struct {
    state: *State,

    pub fn fromState(state: ?*State) Lua {
        return .{ .state = state.? };
    }

    pub fn newLib(lua: Lua, list: []const FnReg) void {
        lua.newLibTable(list);
        lua.setFuncs(list, 0);
    }

    pub fn newLibTable(lua: Lua, list: []const FnReg) void {
        lua.createTable(0, @intCast(i32, list.len));
    }

    pub fn createTable(lua: Lua, num_arr: i32, num_rec: i32) void {
        c.lua_createtable(lua.state, num_arr, num_rec);
    }

    pub fn setFuncs(lua: Lua, funcs: []const FnReg, num_upvalues: i32) void {
        for (funcs) |f| {
            if (f.func) |func| {
                var i: i32 = 0;
                // copy upvalues to the top
                while (i < num_upvalues) : (i += 1) lua.pushValue(-num_upvalues);
                lua.pushClosure(func, num_upvalues);
            } else lua.pushBoolean(false); // register a placeholder
            lua.setField(-(num_upvalues + 2), f.name);
        }
        lua.pop(num_upvalues);
    }

    pub fn pop(lua: Lua, n: i32) void {
        lua.setTop(-n - 1);
    }

    pub fn setTop(lua: Lua, index: i32) void {
        c.lua_settop(lua.state, index);
    }

    pub fn setMetatable(lua: Lua, index: i32) void {
        _ = c.lua_setmetatable(lua.state, index);
    }

    pub fn setField(lua: Lua, index: i32, k: [:0]const u8) void {
        c.lua_setfield(lua.state, index, k.ptr);
    }

    pub fn pushBoolean(lua: Lua, b: bool) void {
        c.lua_pushboolean(lua.state, @boolToInt(b));
    }

    pub fn pushNumber(lua: Lua, n: Number) void {
        c.lua_pushnumber(lua.state, n);
    }

    pub fn pushValue(lua: Lua, index: i32) void {
        c.lua_pushvalue(lua.state, index);
    }

    pub fn pushClosure(lua: Lua, c_fn: CFn, n: i32) void {
        c.lua_pushcclosure(lua.state, c_fn, n);
    }

    pub fn checkNumber(lua: Lua, arg: i32) Number {
        return c.luaL_checknumber(lua.state, arg);
    }
};

pub const Number = c.lua_Number;
pub const CFn = *const fn (state: ?*State) callconv(.C) c_int;
pub const FnReg = struct {
    name: [:0]const u8,
    func: ?CFn,
};

const c = @cImport({
    @cInclude("lua.h");
    @cInclude("lauxlib.h");
});
