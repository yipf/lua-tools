local make_set

local add=function(s1,s2)
	local set=make_set()
	for k,v in pairs(s1) do set[k]=v end
	for k,v in pairs(s2) do set[k]=v end
	return set
end

local sub=function(s1,s2)
	local set=make_set()
	for k,v in pairs(s1) do set[k]=v end
	for k,v in pairs(s2) do set[k]=nil end
	return set
end

local make_pair=function(v1,v2)
	local t=type(v1)=="table" and {unpack(v1)} or {v1}
	table.insert(t,v2)
	return t
end

local mul=function(s1,s2)
	local set=make_set()
	for k1,v1 in pairs(s1) do
		for k2,v2 in pairs(s2) do
			set[make_pair(k1,k2)]=true
		end
	end
	return set
end

local belong_to_set=function(set,value,eq_func)
	for k,v in pairs(set) do
		if not eq_func(value,k) then return false end
	end
	return true
end

local in_set=function(set_table,value,eq_func)
	for i,set in ipairs(set_table) do
		if belong_to_set(set,value,eq_func) then return i end
	end
end

local div=function(set,eq_func)
	local set_table={}
	local push=table.insert
	for k,v in pairs(set) do
		v=in_set(set_table,k,eq_func)
		if v then
			set_table[v][k]=v
		else
			push(set_table,make_set({k}))
		end
	end
	return make_set(set_table)
end

local len=function(set)
	local n=0
	for k,v in pairs(set) do n=n+1 end
	return n
end

local le=function(s1,s2) 
	if len(s1)>=len(s2) then return false end
	for k,v in pairs(s1) do 
		if not s2[k] then return false end 
	end
	return true
end

local le=function(s1,s2)
	return not lt(s2,s1)
end

local eq=function(s1,s2)
	return len(s1)==len(s2) and le(s1,s2) and le(s2,s1)
end

local matatable_of_set={__add=add,__sub=sub,__len=len,__eq=eq,__lt=lt,__le=le,__mul=mul,__div=div}

make_set=function(arr)
	local set={}
	if type(arr)=="table" then
		for i,v in ipairs(arr) do set[v]=i end
	end
	return setmetatable(set,matatable_of_set)
end

local set2str_
set2str_=function(set)
	if type(set)~="table" then  return tostring(set) end
	if getmetatable(set)~=matatable_of_set then  return "("..table.concat(set,",")..")" end
	local t={}
	local push=table.insert
	for k,v in pairs(set) do
		push(t,set2str_(k))
	end
	return "["..table.concat(t,",").."]"
end

print_set=function(set)
	print(set2str_(set))
end

set2str=set2str_

-------------------------------------------------------------------------------------------------------
-- test
-------------------------------------------------------------------------------------------------------
local A=make_set{1,2,3}
local B=make_set{1,2,3,4}
local C=make_set{A,B}
local D=make_set{A,B,3}
local E=make_set{12,22,32,42,56,59,58,66,76}

print_set(A)

print_set(A-B)
print_set(B-A)
print_set(A*B)
print_set(C)
print_set(C-D)
print_set(C==D)
print_set(C+D)

local R=function(a,b)
	return (a-b)%10==0
end

print_set(E/R)
