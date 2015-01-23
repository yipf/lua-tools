
local rawset,rawget,type=rawset,rawget,type

local id=function(o)
	return o
end

make_factory=function(f) -- f(key)=value 
	local factory={}
	f=f or id
	return function(key,value)
		if value then rawset(factory,key,value); return value end
		value=rawget(factory,key)
		if not value then value=f(key); rawset(factory,key,value); end
		return value
	end
end

make_map=function(key2value)
	local map={}
	key2value=key2value or id
	return function(key,value)
		if not key then 
			return map 
		elseif not value then
			value=map[key]
			if not value then value=key2value(key); map[key]=value end
		else
			map[key]=value
		end
		return value
	end
end

local concat=table.concat

make_counter=function(sep)
	sep=sep or "."
	local counters,id={}
	return function(key,sid)
		id=rawget(counters,key)
		if not id then 
			id=sid or 0
		else
			id=id+1
		end
		rawset(counters,key,id)
		return type(key)=='number' and key>1 and concat(counters,sep,1,key) or id
	end
end

-- test 
--~ local c=make_counter(".")

--~ print(c(1,1))
--~ print(c(1,0))
--~ print(c(1,0))
--~ print(c(1,0))
--~ print(c(2,1))
--~ print(c(2,0))
--~ print(c(2,0))
--~ print(c(2,0))
--~ print(c(1,0))

