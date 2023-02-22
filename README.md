Example Lua extension with a single function

This is the `simple` branch in which all files are self contained.
Other branches:
- `pkg`: only contains Zig package with Lua API wrapper in a Zig module
- `use-pkg`: contains this extension and uses the above as a dependency

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
