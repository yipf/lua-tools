local F,V={},{}

local LINE_PAT="^(.-)(=)(.-)$"

local gmatch,gsub,match=string.gmatch,string.gsub,string.match

local get_args=function(str)
	local args,i={},0
	for w in gmatch(str,"%S+") do
		args[i]=w; i=i+1;
	end
	return args
end

local make_pattern=function(name,content)
	local t=get_args(name)
	t.BODY=content
	return t
end

local make_eval=function(t)
	return function(s,str,e)
		str=t[str] or str
		return s..str..e
	end
end

local eval
eval=function(str)
	print("eval:",str)
	local value=V[str]
	if value then return value end
	-- begin eval
	local t=get_args(str)
	local f=t[0]
	f=f and F[f]
	if not f then return str end -- no function found
	local n=#t
	for i,v in ipairs(f) do 	-- pattern match
		if #v==n then f=v; break; end
	end
	if not f.BODY then return str end -- no pattern found
	for i,v in ipairs(f) do t[v]=t[i] end
	value=(gsub((gsub(f.BODY,"%s*%w[%w%s]*%s*",eval)).." ","(%s)(%w+)(%s)",make_eval(t)))
	V[str]=value
	return value
end

local parse_file=function(path)
	local f=io.open(path)
	local name,op,content
	local func,pattern
	local push=table.insert
	if f then
		for line in f:lines() do
			if match(line,"^%s*[^#%s]")then -- not empty or comment
				name,op,content=match(line,LINE_PAT)
				if op=="=" then -- function definition
					pattern=make_pattern(name,content)
					name=pattern[0]
					if name then
						func=F[name]
						if not func then func={}; F[name]=func; end
						push(func,pattern)
					end
				else
					push(F,eval(line))
				end
			end
		end
		f:close()
	end
end

parse_file("../test/test.hs")
for i,v in ipairs(F) do
	print(i,"=",v)
end

