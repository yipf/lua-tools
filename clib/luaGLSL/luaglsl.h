#ifndef LUAGLSL_H
#define LUAGLSL_H

#include "luautils.h"

#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glext.h>

#define FUNC_UNIT(name) {#name,name}
#define SET( name ) lua_pushinteger(L,GLSL_##name); lua_setfield (L,-2, #name);

static char * copy_string_(const char * p);
int error_( lua_State *L,const char* msg);

static char *shaderLoadSource(const char *filePath);
static char* genShader(GLuint program,GLenum type, const char *filePath);

FUNC_( load );
FUNC_( apply );

static const luaL_reg MyluaGLSLFunctions [] =
{
	FUNC_UNIT(load ),
	FUNC_UNIT(apply),
	{NULL, NULL}
};

int luaopen_luaGLSL(lua_State* L) ;

#endif
