make_generator=function(t,key_index)
	local id,value
	local rawget=rawget
	return key_index and function()
		id,value=next(t,id)
		return value,id
	end or function()
		id=id and id+1 or 1
		v=rawget(t,id)
		return value,id
	end
end

local t={2,2,3}

number_generator=function(min,step,max)
	min=min or 0
	step=step or 1
	max=max or 1
	min=min-step
	return function(stop)
		if stop then max=min return max end
		min=min+step
		return min<max and min
	end
end

for i in number_generator(0,1,10) do
	print(i)
end