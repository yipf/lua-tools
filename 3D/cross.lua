require "3D/vector"

local v3d_dot,v3d_mult,v3d_add= v3d_dot,v3d_mult,v3d_add

-- get the cross point of a line to a plane
line2plane=function(p,v,o,n)
	local a,b,c=v3d_dot(o,n),v3d_dot(p,n),v3d_dot(v,n)
	return c~=0 and v3d_add(p,v3d_mult((a-b)/c,v))
end