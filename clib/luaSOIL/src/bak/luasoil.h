#ifndef LUASOIL_H
#define LUASOIL_H

#include "luautils.h"

#include <GL/gl.h>
#include <GL/glu.h>

#include "SOIL.h"

#define FUNC_UNIT(name) {#name,name}

#define SET( name ) lua_pushinteger(L,SOIL_##name); lua_setfield (L,-2, #name);

static char ERROR_MSG[][100]={"OK!","Too little arguments!","Incorrect argument"};

static char * copy_string_(const char * p);
static int error_( lua_State *L,const char* msg);
static int screen_to_texture_(int x, int y,unsigned int width, unsigned int height,int reused,int flag);

FUNC_( load );
FUNC_( load_HDR );
FUNC_( save_screen);
FUNC_( screen_to_texture );


FUNC_( load_img );
FUNC_( save_img );
FUNC_( get_img );
FUNC_( set_img );

static const luaL_reg MyLuaSOILFunctions [] =
{
	FUNC_UNIT(load ),
	FUNC_UNIT(load_HDR),
	FUNC_UNIT(save_screen),
	FUNC_UNIT(screen_to_texture),

	FUNC_UNIT(load_img),
	FUNC_UNIT(save_img),
	FUNC_UNIT(get_img),
	FUNC_UNIT(set_img),
     
     {NULL, NULL}
};

int luaopen_luaSOIL(lua_State* L) ;

#endif
