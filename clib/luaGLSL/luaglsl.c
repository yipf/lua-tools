
/*
 * Copyright (C) 2010 Josh A. Beam
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "luaglsl.h"


int error_( lua_State *L,const char* msg)
{
  lua_pushnil(L);
  lua_pushstring(L,msg);
  return 2;
}

/*
 * Returns a string containing the text in
 * a vertex/fragment shader source file.
 */
char *shaderLoadSource(const char *filePath)
{
	const size_t blockSize = 512;
	FILE *fp;
	char buf[blockSize];
	char *source = NULL;
	size_t tmp, sourceLength = 0;
	/* open file */
	fp = fopen(filePath, "r");
	if(!fp) {
		fprintf(stderr, "shaderLoadSource(): Unable to open %s for reading\n", filePath);
		return NULL;
	}
	/* read the entire file into a string */
	while((tmp = fread(buf, 1, blockSize, fp)) > 0) {
		char *newSource = malloc(sourceLength + tmp + 1);
		if(!newSource) {
			fprintf(stderr, "shaderLoadSource(): malloc failed\n");
			if(source)
				free(source);
			return NULL;
		}
		if(source) {
			memcpy(newSource, source, sourceLength);
			free(source);
		}
		memcpy(newSource + sourceLength, buf, tmp);
		source = newSource;
		sourceLength += tmp;
	}
	/* close the file and null terminate the string */
	fclose(fp);
	if(source)
		source[sourceLength] = '\0';

	return source;
}

/*
 * Returns a shader object containing a shader
 * compiled from the given GLSL shader file.
 */
char* genShader(GLuint program,GLenum type, const char *filePath)
{
	char *source;
	char *log=0;
	GLuint shader;
	GLint length, result;
	/* get shader source */
	source = shaderLoadSource(filePath);
	if(!source)
		return 0;
	/* create shader object, set the source, and compile */
	shader = glCreateShader(type);
	length = strlen(source);
	glShaderSource(shader, 1, (const char **)&source, &length);
	glCompileShader(shader);
	free(source);
	/* make sure the compilation was successful */
	glGetShaderiv(shader, GL_COMPILE_STATUS, &result);
	if(result == GL_FALSE) {
		/* get the shader info log */
		glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &length);
		log = malloc(length);
		glGetShaderInfoLog(shader, length, &result, log);
		/* print an error message and the info log */
		fprintf(stderr, "shaderCompileFromFile(): Unable to compile %s: %s\n", filePath, log);
		free(log);
		glDeleteShader(shader);
	}else{
		glAttachShader(program, shader);
		glDeleteShader(shader);
	}
	return log;
}

FUNC(load)
{
	GLuint g_program;
	GLint result;
	char* compile_err;
	int n= lua_gettop(L);
	if (n<1) return error_(L,"need at least one shader filename!\n");
	g_program = glCreateProgram();
	if(n>0 && CHECK(string,1))
	{
		compile_err=genShader(g_program, GL_VERTEX_SHADER, GET(string,1));
		if(compile_err) error_(L,compile_err);
	}
	if(n>1 && CHECK(string,2))	
	{
		compile_err=genShader(g_program, GL_FRAGMENT_SHADER, GET(string,2));
		if(compile_err) error_(L,compile_err);
	}
	glLinkProgram(g_program);
	glGetProgramiv(g_program, GL_LINK_STATUS, &result);
	if(result == GL_FALSE) {
		GLint length;
		char *log;
		/* get the program info log */
		glGetProgramiv(g_program, GL_INFO_LOG_LENGTH, &length);
		log = malloc(length);
		glGetProgramInfoLog(g_program, length, &result, log);
		/* print an error message and the info log */
		fprintf(stderr, "sceneInit(): Program linking failed: %s\n", log);
		free(log);
		/* delete the program */
		glDeleteProgram(g_program);
		g_program = 0;
	}
	lua_pushlightuserdata(L,&g_program);
	return 1;
}

FUNC(apply)
{
	int n= lua_gettop(L);
	if (n<1) {glUseProgram(0); return 0; } /*	if no args are provided, delete current program 	*/
	if(n>0 && CHECK(lightuserdata,1))	{
		glUseProgram(GET(userdata,1));
	}else{
		return error_(L,"Not a valid shader program data type!\n");
	}
}




int luaopen_luaSOIL(lua_State* L)
{
    luaL_register(L, "soil", MyluaGLSLFunctions);
    return 1;
}
