package.cpath="./?.so;"..package.cpath

require "luaLISP"

local ft={
	['+']=function(a,b) return a+b end,
	['-']=function(a,b) return a-b end,
	['*']=function(a,b) return a*b end,
	['/']=function(a,b) return a/b end,
}

local type=type

local eval
eval=function(t)
	local type,rawget=type,rawget
	local v
	local n=#t
	for i=2,n do
		v=rawget(t,i)
		if type(v)=='table' then
			rawset(t,i,eval(v))
		end
	end
	v=rawget(t,1)
	v=v and rawget(ft,v)
	return v and v(unpack(t,2,n))
end

local lisp2table=LISP.loadstring
eval_str=function(str)
	return eval(rawget(lisp2table(str),1))
end

local str=[[

(+ (* 2 4) (- 2 1))

]]

print(eval_str(str))