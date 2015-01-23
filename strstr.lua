local assert,loadstring=assert,loadstring

local gmatch,match=string.gmatch,string.match

local push=table.insert

local do_string_=function(str)
	str=assert(loadstring(str))
	return str and str()
end

do_string=do_string_

-- extend
eval_str=function(str)
	return do_string_("return "..str)
end

str2array=function(str,pat,f,arr,s)
	pat=pat or "%S+"
	arr=arr or {}
	local n=0
	s=s or 1
	for w in gmatch(str,pat) do
		rawset(arr,s+n,f and f(w) or w)
		n=n+1
	end
	return arr,n
end

trim=function(str)
	return match(str,"^%s*(.-)%s*$")
end

local str2arr,trim_,args,n=str2array,trim,{}
local unpack=unpack
str2args=function(str,pat,f)
	t,n=str2arr(str,pat,f,t,1)
	return unpack(t,1,n)
end

--~ print(tonumber(a))


--~ print(str2args("1/2/3".."/","(.-)/"))

--~ local s,n=str2args("aaa bbb")
--~ print(s)
--~ print(str2args("aaa bbb"))

-- test
--~ print(eval_str("4"))



--~ print(match("aaAa3 ss","%a+"))