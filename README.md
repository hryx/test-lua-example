Example Lua extension with a single function

This is the `use-pkg` branch which depends on the remote package defined in `pkg`.
Other branches:
- `pkg`: only contains the Zig package which this branch depends on
- `simple`: self-contained version with no package management

Usage:

```
$ zig build
$ lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> package.cpath = "zig-out/lib/lib?.dylib;zig-out/lib/lib?.so;zig-out/lib/?.dll"
> corncob = require("corncob")
> corncob.chomp(44)
440.0
```
