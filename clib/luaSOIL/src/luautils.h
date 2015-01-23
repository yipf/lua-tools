#ifndef LUAUTILS_H
#define LUAUTILS_H

#include <lua5.1/lua.h>
#include <lua5.1/lualib.h>
#include <lua5.1/lauxlib.h>


#define FUNC(name) int name (lua_State *L)
#define FUNC_(name) static FUNC(name)
#define ERROR (msg)  lua_pushnil(L); lua_pushstring(L,msg);return 2;

#define CHECK(t,n) lua_is##t(L,n)
#define GET(t,n) lua_to##t(L,n)

#define CHECK_GET(t,n,v) CHECK(t,n)?GET(t,n):(v)

#endif


