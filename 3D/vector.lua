
local unpack=unpack
local sqrt=math.sqrt

v3d_cross=function(V1,V2)
	local x1,y1,z1=unpack(V1)
	local x2,y2,z2=unpack(V2)
	return {y1*z2-y2*z1,z1*x2-z2*x1,x1*y2-x2*y1}
end

v3d_dot=function(V1,V2)
	local x1,y1,z1=unpack(V1)
	local x2,y2,z2=unpack(V2)
	return x1*x2+y1*y2+z1*z2
end

v3d_add=function(V1,V2)
	local x1,y1,z1=unpack(V1)
	local x2,y2,z2=unpack(V2)
	return {x1+x2,y1+y2,z1+z2}
end

v3d_sub=function(V1,V2)
	local x1,y1,z1=unpack(V1)
	local x2,y2,z2=unpack(V2)
	return {x1-x2,y1-y2,z1-z2}
end

v3d_norm=function(V)
	local x,y,z=unpack(V)
	return sqrt(x*x+y*y+z*z)
end

v3d_normalize=function(V)
	local x,y,z=unpack(V)
	local n=sqrt(x*x+y*y+z*z)
	if n==0 then return {0,0,0} end
	return {x/n,y/n,z/n}
end

v3d_mult=function(s,V)
	local x,y,z=unpack(V)
	return {s*x,s*y,s*z}
end


