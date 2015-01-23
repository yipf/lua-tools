require "3D/vector"

local cross,normalize,mult,add=v3d_cross,v3d_normalize,v3d_mult,v3d_add
local unpack=unpack

build_XYZ=function(X,Y,Z)
	if not X then 	-- Y is prime
		X=normalize(cross(Y,Z));Z=normalize(cross(X,Y))
	elseif not Y then -- Z is prime
		Y=normalize(cross(Z,X));X=normalize(cross(Y,Z))
	elseif not Z then -- X is prime
		Z=normalize(cross(X,Y));Y=normalize(cross(Z,X))
	end
	return X,Y,Z
end

v3d2v3d=function(V,X,Y,Z)
	local x,y,z=unpack(V)
	return add(mult(x,X),add(mult(y,Y),mult(z,Z)))
end

