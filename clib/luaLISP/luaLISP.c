#include "luaLISP.h"

#include <string.h>
#include <ctype.h>
#include <stdlib.h>

int push_to_table(lua_State *L,int table_pos){
	size_t n=lua_objlen(L,table_pos)+1;
	lua_rawseti(L,table_pos,n);
	return n;
}

int push_atom(lua_State *L,int table_pos,const string str,size_t s,size_t e){
	int top;
	char* strstr;
	lua_pushlstring(L,str+s,e-s);
	top=lua_gettop (L);
	if (lua_isnumber(L,top)){
		lua_pushnumber(L,lua_tonumber(L,top));
	}else{
		strstr=lua_tostring(L,top);
		if(strcoll(strstr,"#t")==0) lua_pushboolean(L,1);
		else if(strcoll(strstr,"#f")==0) lua_pushboolean(L,0);
	}
	push_to_table(L,table_pos);
	return e+1;
}

int push_string(lua_State *L,int table_pos,const string str,size_t s,size_t e){
	size_t start=s;
	while( s<e && ( (str[s])!='"' || str[s-1]=='\\' )) s++;
	lua_pushlstring(L,str+start,s-start);
	push_to_table(L,table_pos);
	return s+1;
}


int parse_list(lua_State *L,int table_pos,const string str,size_t s,size_t e){
	int ch;
	int top;
	int start=s;
	while(s<e&&(ch=str[s])){
		switch(ch){
			case '(':
					if(start<s) push_atom(L,table_pos,str,start,s);
					lua_newtable(L);
					top=lua_gettop(L);
					s=parse_list(L,top,str,s+1,e)+1;
					lua_settop (L, top);
					push_to_table(L,table_pos);
					start=s;
				break;
			case ')':
					if(start<s) push_atom(L,table_pos,str,start,s);
					return s+1; 
				break;
			case '"':
					if(start<s) push_atom(L,table_pos,str,start,s);
					s=push_string(L,table_pos,str,s+1,e)+1;
					start=s;
				break;
			default:
					if(isspace(ch)){
						if(start<s) push_atom(L,table_pos,str,start,s);
						start=s+1;
					}
					s++;
				break;
		}
	}
	if(start<s) push_atom(L,table_pos,str,start,s);
	return s+1;
}

static int loadstring (lua_State *L){
	int n= lua_gettop(L);
	char* str=(n>0&&lua_isstring(L,1))?lua_tostring(L,1):0;
	if(str){
		lua_newtable(L);
		n=lua_gettop(L);
		parse_list(L,n,str,0,strlen(str));
		lua_settop (L, n);
        return 1;
	}
	ERROR ("Can't creat LISP lists from the input string!");
}

int luaopen_luaLISP(lua_State* L){
	luaL_register(L, "LISP", MyLuaLISPFunctions);
	return 1;
}