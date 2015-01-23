local V={ sin=function (x) 
		x=x and tonumber(x)
		return x and math.sin(x) or "ERROR"
	end,
	["+"]=function (x,y) 
		x=tonumber(x); y=tonumber(y);
		return x and y and x+y or "ERROR"
	end,
}

local match,gsub,sub=string.match,string.gsub,string.sub

local eval

local PATS={ ["("]="(%b())()",['"']="(%b\"\")()"}

local str2units=function(str)
	print(str)
	local t={}
	local s,w=1
	local i=0
	while s do
		s,w=match(str,"()(%S)",s)
		if not w then break end
		w,s=match(str,PATS[w] or "(%S+)()",s)
		t[i]=w
		i=i+1
	end
	return t
end

eval=function(str)
	local t=str2units(sub(str,2,-2))
	local n=t[0]
	n=n and V[n] or n
	if type(n)=="table" then  -- is a user-defined function
		for i,v in ipairs(n) do
			t[v]=t[i]
		end
--~ 		n=gsub((gsub(n.BODY,"%b()",eval)),"{(%w)}",t) 
		n=gsub(gsub(n.BODY,"{(%w)}",t),"%b()",eval) -- replace first, eval second
	elseif type(n)=="function" then -- is a native function
		n=n(unpack(t))
	end
	return n
end

local make_function=function(args,content)
	local n=string.len(args)
	local t={}
	for i=1,n do
		t[i]=sub(args,i,i)
	end
	t.BODY=content
	return t
end

local parse_file=function(path)
	local f=io.open(path)
	local name,op,args,content
	if f then
		for line in f:lines() do
			name,op,args,content=match(line,"^%s*(%w+)%s*([%.%=])(%a*)%s+(.-)%s*$")
			if op=="." then 
				V[name]=make_function(args,content)
			elseif op=="=" then
				V[name]=gsub(content,"%b()",eval)
			end
		end
		f:close()
	end
end

compute=function(path,DEBUG)
	parse_file(path)
	if DEBUG then
		print("-----------Global Tables:")
		for k,v in pairs(V) do
			print(k,(type(v)=='table') and v.BODY or v)
		end
		print("-----------END----------")
	end
	return V["V"]
end

local v=compute("../test/test.txt",1)

print(v)