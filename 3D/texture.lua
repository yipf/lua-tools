require "functor"

local rawset,rawget,tonumber,unpack=rawset,rawget,tonumber,unpack
local match=string.match

local texture_hooks={}

local KEY_VALUE_PAT="^(%S+)%s*(.-)%s*$"

local str2texture=function(str)
	local key,args=match(str,KEY_VALUE_PAT)
	key=key and rawget(texture_hooks,key)
	if not key then return end
	return key(args)
end

-- exports
texture_ids=make_factory(str2texture)

register_texture_hook=function(key,value)
	rawset(texture_hooks,key,value)
end