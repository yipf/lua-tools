#ifndef LUALISP_H
#define LUALISP_H

#include <lua5.1/lua.h>
#include <lua5.1/lualib.h>
#include <lua5.1/lauxlib.h>

typedef char* string;
typedef lua_Number number;

#include <string.h>

static int push_to_table(lua_State *L,int table_pos);

static int  push_atom(lua_State *L,int table_pos,const string str,size_t s,size_t e);

static int  push_string(lua_State *L,int table_pos,const string str,size_t s,size_t e);

static int parse_list(lua_State *L,int table_pos,const string str,size_t s,size_t e);

static int loadstring (lua_State *L);

#define FUNC_UNIT(name) {#name,name}
#define ERROR(msg)  lua_pushnil(L); lua_pushstring(L,msg);return 2;

static const luaL_reg MyLuaLISPFunctions [] =
{
    FUNC_UNIT(loadstring), 
	{NULL, NULL}
};

#endif
