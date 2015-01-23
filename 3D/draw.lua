require "functor"

local rawset,rawget,tonumber,unpack=rawset,rawget,tonumber,unpack
local match=string.match

local draw_hooks={}

local HOOK_ARG_PAT="^(%S+)%s*(.-)%s*$"

local GenLists,NewList,EndList,DeleteLists=gl.GenLists,gl.NewList,gl.EndList,gl.DeleteLists

--~ local str2draw=function(str)
--~ 	local key,args=match(str,HOOK_ARG_PAT)
--~ 	key=key and rawget(draw_hooks,key)
--~ 	if not key then return end
--~ 	local id=GenLists(1)
--~ 	NewList(id,'COMPILE')
--~ 		key(args)
--~ 	EndList()
--~ 	return id
--~ end

local draw_=function(obj)
	local hook,args
	local tp=type(obj)
	if tp~="table" then
		hook,args=match(obj,HOOK_ARG_PAT)
	else
		hook=obj[1]; args=obj;
	end
	hook=hook and rawget(draw_hooks,hook)
	if not hook then return end
	return hook(args)
end

--~ local key2id=function(key)
--~ 	local hook,args
--~ 	local tp=type(key)
--~ 	if tp~="table" then
--~ 		hook,args=match(key,HOOK_ARG_PAT)
--~ 	else
--~ 		hook=key[1]; args=key;
--~ 	end
--~ 	hook=hook and rawget(draw_hooks,hook)
--~ 	if not hook then return end
--~ 	local id,state=GenLists(1)
--~ 	NewList(id,'COMPILE')
--~ 		state=hook(args)
--~ 	EndList()
--~ 	if not state then DeleteLists(id,1); return end
--~ 	return id
--~ end

local key2id=function(key)
	local id,state=GenLists(1)
	NewList(id,'COMPILE')
		state=draw_(key)
	EndList()
	if not state then DeleteLists(id,1); return end
	return id
end

-- exports
draw_ids=make_factory(key2id)

draw=draw_

register_draw_hook=function(name,hook)
	rawset(draw_hooks,name,hook)
end
