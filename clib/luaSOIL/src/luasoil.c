#include "luasoil.h"

#include <stdlib.h>
#include <string.h>

char * copy_string_(const char * p)
{
  GLsizei len=strlen(p);
  char * s=(char*)malloc(sizeof(char)*(len+1));
  GLsizei i=0;
  for(i=0;i<len;++i){
    s[i]=p[i];
  }
  s[i]='\0';
  return s;
}

int screen_to_texture_(int x, int y,unsigned int width, unsigned int height,int reused,int flag)
{
  unsigned char *pixel_data;
  /*	error checks	*/
  if( (width < 1) || (height < 1) || (x < 0) || (y < 0) ) return 0;
  /*  Get the data from OpenGL	*/
  pixel_data = (unsigned char*)malloc( 3*width*height );
  glReadPixels (x, y, width, height, GL_RGB, GL_UNSIGNED_BYTE, pixel_data);
  return SOIL_create_OGL_texture( pixel_data,width, height,3,reused,flag);
}

int error_( lua_State *L,const char* msg)
{
  lua_pushnil(L);
  lua_pushstring(L,msg);
  return 2;
}

FUNC(load)
{
    int n= lua_gettop(L);
    char* str=0;
    if (n<1 || !CHECK(string,1) ) error_(L,"need a filename!\n");
    str=copy_string_(GET(string,1));
    int id=SOIL_load_OGL_texture
	(
		str,
		CHECK_GET(number,2,SOIL_LOAD_AUTO),
		CHECK_GET(number,3,SOIL_CREATE_NEW_ID),
		CHECK_GET(number,4,SOIL_FLAG_MIPMAPS)
	);
    if (id)
    {
        lua_pushinteger(L,id);
        return 1;
    }
    error_(L,"failed to load file!\n");
}

FUNC(load_HDR)
{
    int n= lua_gettop(L);
    char* str=0;
    if (n<1 || !CHECK(string,1) ) error_(L,"need a filename!\n");
    str=copy_string_(GET(string,1));
    int id=SOIL_load_OGL_HDR_texture
	(
		str,
		CHECK_GET(number,2,SOIL_HDR_RGBE),
		CHECK_GET(number,3,0),
		CHECK_GET(number,4,SOIL_CREATE_NEW_ID),
		CHECK_GET(number,5,SOIL_FLAG_MIPMAPS)
	);
    if (id)
    {
        lua_pushinteger(L,id);
        return 1;
    }
    error_(L,"failed to load file!\n");
}

FUNC( save_screen)
{
    int n= lua_gettop(L);
    char* str=0;
    if (n<1 || !CHECK(string,1) ) return error_(L,"need a filename!\n");
    str=copy_string_(GET(string,1));
    int id=SOIL_save_screenshot
	(
		str,
		CHECK_GET(number,2,SOIL_SAVE_TYPE_TGA),
		CHECK_GET(number,3,0),
		CHECK_GET(number,4,0),
		CHECK_GET(number,5,0),
		CHECK_GET(number,6,0)
	);
    if (id)
    {
        lua_pushinteger(L,id);
        return 1;
    }
    return error_(L,"failed to load file!\n");
}

FUNC( screen_to_texture )
{
    int id=screen_to_texture_
	(
	 CHECK_GET(number,1,0),
	 CHECK_GET(number,2,0),
	 CHECK_GET(number,3,0),
	 CHECK_GET(number,4,0),
	 CHECK_GET(number,5,SOIL_CREATE_NEW_ID),
	 CHECK_GET(number,6,SOIL_FLAG_MIPMAPS)
	);
    if (id)
    {
        lua_pushinteger(L,id);
        return 1;
    }
    return error_(L,"failed to load file!\n");
}


FUNC( load_img )
{
	int n= lua_gettop(L);
	unsigned char* img;
	int width;
	int height;
	int channels; 
	if (n<1 || !CHECK(string,1) ) return error_(L,"need a filename!\n");
	img= SOIL_load_image(
		GET(string,1),
		&width,&height,&channels,
		CHECK_GET(number,2,SOIL_LOAD_AUTO)
	);
	
	if (img==NULL) return error_(L,SOIL_last_result());
	
	lua_pushlightuserdata(L,img);
	lua_pushinteger(L,width);
	lua_pushinteger(L,height);
	lua_pushinteger(L,channels);
	return 4;					
}

FUNC( save_img )
{
	int n= lua_gettop(L);
	int r=0;
	if (n<1 || !CHECK(string,1) ) return error_(L,"need an image!\n");
	SOIL_save_image(
		GET(string,1),
		CHECK_GET(number,2,SOIL_SAVE_TYPE_TGA),
		CHECK_GET(number,3,0),
		CHECK_GET(number,4,0),
		CHECK_GET(number,5,0),
		CHECK_GET(userdata,6,0)
	);
	return error_(L,SOIL_last_result());
}

FUNC( get_img )
{
	int n=lua_gettop(L);
	unsigned char* img;
	unsigned int pos;
	if (n>0) img=CHECK_GET(userdata,1,0);
	if (n>1) pos=CHECK_GET(number,2,0);
	if (img)
	{
		lua_pushnumber(L,img[pos]);
		return 1;
	}
	return error_(L,"error to get img!\n");
}

FUNC( set_img )
{
	int n=lua_gettop(L);
	unsigned char* img;
	unsigned int pos;
	char v;
	if (n>0) img=CHECK_GET(userdata,1,0);
	if (n>1) pos=CHECK_GET(number,2,0);
	if (n>2) v=CHECK_GET(number,3,0);
	if (img)
	{
		img[pos]=v;
		lua_pushlightuserdata(L,img);
		return 1;
	}
	return error_(L,"error to set img!\n");
}

FUNC( create_img )
{
	int n=lua_gettop(L);
	unsigned char *img;
	unsigned int width,height,channels,force_channels;
	//~ create memory buffer from input
	width=CHECK_GET(number,1,1);
	height=CHECK_GET(number,2,1);
	force_channels=CHECK_GET(number,3,1);
	//~ channels=force_channels>3?4:3;
	img=(unsigned char *)calloc(width*height,force_channels);
	if(img==NULL){
		return error_(L,"Fail to create image in memory!\n");
	}
	lua_pushlightuserdata(L,img);
	lua_pushinteger(L,width);
	lua_pushinteger(L,height);
	lua_pushinteger(L,channels);
	return 4;
}


int luaopen_luaSOIL(lua_State* L)
{
	//~ register functions
    luaL_register(L, "soil", MyLuaSOILFunctions); 
	//~ register constants
    SET( LOAD_AUTO );
    SET( LOAD_L );
    SET( LOAD_LA );
    SET( LOAD_RGB );
    SET( LOAD_RGBA);

    SET(CREATE_NEW_ID);

    SET(FLAG_POWER_OF_TWO );
    SET(FLAG_MIPMAPS );
    SET(FLAG_TEXTURE_REPEATS );
    SET(FLAG_MULTIPLY_ALPHA );
    SET(FLAG_INVERT_Y );
    SET(FLAG_COMPRESS_TO_DXT );
    SET(FLAG_DDS_LOAD_DIRECT );
    SET(FLAG_NTSC_SAFE_RGB );
    SET(FLAG_CoCg_Y );
    SET(FLAG_TEXTURE_RECTANGLE );

    SET(SAVE_TYPE_TGA );
    SET(SAVE_TYPE_BMP );
    SET(SAVE_TYPE_DDS );

    SET(HDR_RGBE );
    SET(HDR_RGBdivA );
    SET(HDR_RGBdivA2 );

    return 1;
}
