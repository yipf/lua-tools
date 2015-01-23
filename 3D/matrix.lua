-- all matrix is colune-primed

local rawset,rawget=rawset,rawget

make_identity=function(mat)
	mat=mat or {}
	rawset(mat,1,1);	rawset(mat,2,0);	rawset(mat,3,0);	rawset(mat,4,0);
	rawset(mat,5,0);	rawset(mat,6,1);	rawset(mat,7,0);	rawset(mat,8,0);
	rawset(mat,9,0);	rawset(mat,10,0);	rawset(mat,11,1);	rawset(mat,12,0);
	rawset(mat,13,0);	rawset(mat,14,0);	rawset(mat,15,0);	rawset(mat,16,1);
	return mat
end

make_translate=function(mat,tx,ty,tz)
	mat=mat or {}
	rawset(mat,1,1);	rawset(mat,2,0);	rawset(mat,3,0);	rawset(mat,4,0);
	rawset(mat,5,0);	rawset(mat,6,1);	rawset(mat,7,0);	rawset(mat,8,0);
	rawset(mat,9,0);	rawset(mat,10,0);	rawset(mat,11,1);	rawset(mat,12,0);
	rawset(mat,13,tx);	rawset(mat,14,ty);	rawset(mat,15,tz);	rawset(mat,16,1);
	return mat
end

make_scale=function(mat,sx,sy,sz)
	mat=mat or {}
	sx=sx or 1
	sy=sy or sx
	sz=sz or sx
	rawset(mat,1,sx);	rawset(mat,2,0);	rawset(mat,3,0);	rawset(mat,4,0);
	rawset(mat,5,0);	rawset(mat,6,sy);	rawset(mat,7,0);	rawset(mat,8,0);
	rawset(mat,9,0);	rawset(mat,10,0);	rawset(mat,11,sz);	rawset(mat,12,0);
	rawset(mat,13,0);	rawset(mat,14,0);	rawset(mat,15,0);	rawset(mat,16,1);
	return mat
end

local sqrt,cos,sin=math.sqrt,math.cos,math.sin

make_rotate=function(mat,x,y,z,a) -- http://hi.baidu.com/mikeni2006/item/b0c8ade216ab203a4ddcaf85
	mat=mat or {}
	local n,c,s=sqrt(x*x+y*y+z*z),cos(a),sin(a)
	x,y,z=x/n,y/n,z/n
	mat[1]=x*x*(1-c)+c;		mat[5]=x*y*(1-c)-z*s;	mat[9]=x*z*(1-c)+y*s;	mat[13]=0;
	mat[2]=x*y*(1-c)+z*s;	mat[6]=y*y*(1-c)+c;		mat[10]=y*z*(1-c)-x*s;	mat[14]=0;
	mat[3]=x*z*(1-c)-y*s;	mat[7]=y*z*(1-c)+x*s;	mat[11]=z*z*(1-c)+c;	mat[15]=0;
	mat[4]=0;						mat[8]=0	;					mat[12]=0;					mat[16]=1;
	return mat
end

make_project=function(mat,dx,dy,dz,d)
	mat=mat or {}
	dy= dy==0 and 0.01 or dy
	rawset(mat,1,1);	rawset(mat,2,0);	rawset(mat,3,0);	rawset(mat,4,0);
	rawset(mat,5,-dx/dy);	rawset(mat,6,0);	rawset(mat,7,-dz/dy);	rawset(mat,8,0);
	rawset(mat,9,0);	rawset(mat,10,0);	rawset(mat,11,1);	rawset(mat,12,0);
	rawset(mat,13,0);	rawset(mat,14,d or 0);	rawset(mat,15,0);	rawset(mat,16,1);
	return mat
end

local unpack=unpack
mult_matrix=function(m2,m1,m) -- m*v=m2*m1*v
	m=m or {}
	local a11,a21,a31,a41,a12,a22,a32,a42,a13,a23,a33,a43,a14,a24,a34,a44	=	unpack(m1)
	local b11,b12,b13,b14,b21,b22,b23,b24,b31,b32,b33,b34,b41,b42,b43,b44	=	unpack(m2)
	rawset(m,1,a11*b11+a21*b21+a31*b31+a41*b41)
	rawset(m,2,a11*b12+a21*b22+a31*b32+a41*b42)
	rawset(m,3,a11*b13+a21*b23+a31*b33+a41*b43)
	rawset(m,4,a11*b14+a21*b24+a31*b34+a41*b44)
	rawset(m,5,a12*b11+a22*b21+a32*b31+a42*b41)
	rawset(m,6,a12*b12+a22*b22+a32*b32+a42*b42)
	rawset(m,7,a12*b13+a22*b23+a32*b33+a42*b43)
	rawset(m,8,a12*b14+a22*b24+a32*b34+a42*b44)
	rawset(m,9,a13*b11+a23*b21+a33*b31+a43*b41)
	rawset(m,10,a13*b12+a23*b22+a33*b32+a43*b42)
	rawset(m,11,a13*b13+a23*b23+a33*b33+a43*b43)
	rawset(m,12,a13*b14+a23*b24+a33*b34+a43*b44)
	rawset(m,13,a14*b11+a24*b21+a34*b31+a44*b41)
	rawset(m,14,a14*b12+a24*b22+a34*b32+a44*b42)
	rawset(m,15,a14*b13+a24*b23+a34*b33+a44*b43)
	rawset(m,16,a14*b14+a24*b24+a34*b34+a44*b44)
	return m
end

print_matrix=function(m,title)
	print(title or "matrix")
	for i=1,16,4 do
		print(rawget(m,i),rawget(m,i+1),rawget(m,i+2),rawget(m,i+3))
	end
end

-- extern

require "3D/coordinate"
local build_XYZ=build_XYZ

make_coordinate_matrix=function(mat,X,Y,Z)
	mat=mat or {}
	X,Y,Z=build_XYZ(X,Y,Z)
	local xx,xy,xz=unpack(X)
	local yx,yy,yz=unpack(Y)
	local zx,zy,zz=unpack(Z)
	rawset(mat,1,xx);	rawset(mat,2,xy);	rawset(mat,3,xz);	rawset(mat,4,0);
	rawset(mat,5,yx);	rawset(mat,6,yy);	rawset(mat,7,yz);	rawset(mat,8,0);
	rawset(mat,9,zx);	rawset(mat,10,zy);	rawset(mat,11,zz);	rawset(mat,12,0);
	rawset(mat,13,0);	rawset(mat,14,0);	rawset(mat,15,0);	rawset(mat,16,1);
	return mat
end


local rawset,rawget=rawset,rawget
copy_matrix=function(src,dst)
	dst=dst or {}
	for i,v in ipairs(src) do
		rawset(dst,i,v)
	end
	return dst
end

--~ local as,bs,m1,m2,m={},{},{},{},{}
--~ local id
--~ local push,concat=table.insert,table.concat

--~ local format=string.format

--~ local make_id=function(i,j)
--~ 	local id=i*4+j-4
--~ 	local t={}
--~ 	for s=1,4 do
--~ 		push(t,format("a%d%d*b%d%d",s,i,s,j))
--~ 	end
--~ 	str=concat(t,"+")
--~ 	return id,str
--~ end

--~ for i=1,4 do
--~ 	for j=1,4 do
--~ 		push(as,"a"..i..j)
--~ 		push(bs,"b"..j..i)
--~ 		push(m,format("rawset(m,%d,%s)",make_id(i,j)))
--~ 	end
--~ end

--~ print(concat(as,","))
--~ print(concat(bs,","))
--~ print(concat(m,"\n"))


--~ local m1=make_translate({},1,2,3)
--~ print_matrix(m1,"m1")
--~ local m2=make_translate({},8,8,8)
--~ print_matrix(m2,"m2")
--~ print_matrix(mult_matrix(m1,m2),"m1*m2")
