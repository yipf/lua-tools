
--~ require "graph"

--~ require "tarjan"

--~ local G=make_graph(10)

--~ G(1,2,1)
--~ G(1,3,1)
--~ G(2,4,1)
--~ G(3,4,1)
--~ G(3,5,1)
--~ G(4,6,1)
--~ G(4,1,1)
--~ G(5,6,1)

--~ G(7,8,1)
--~ G(8,9,1)
--~ G(9,10,1)
--~ G(10,7,1)


--~ draw_graph(G,"tarjan")

--~ local scc=get_scc(G)

--~ local make_f=function(t)
--~ 	return function(i)
--~ 		return "n"..t[i]
--~ 	end
--~ end

--~ local SG,ref
--~ for i,v in ipairs(scc) do
--~ 	print(table.concat(v,","))
--~ 	if #v>1 then
--~ 		SG,ref=sub_graph(v,G)
--~ 		draw_graph(SG,"tarjan"..tostring(i),make_f(v))
--~ 	end
--~ end


--~ for i=2,4,2 do
--~ 	print(i)
--~ end


--~ local atan,deg=math.atan2,math.deg
--~ get_angle=function(x,z) 	-- calculate the angle from (1,0,) to (x,z) in XOZ plane around Y axis by right hand rule
--~ 	return deg(atan(-z,x))
--~ end

--~ print(get_angle(0,-1))
--~ print(get_angle(1,0))

--~ local sin,cos=math.sin,math.cos
--~ rotate=function(v,angle)
--~ 	local x,y,z=unpack(v)
--~ 	local c,s=cos(angle),sin(angle)
--~ 	return c*x+s*z,y,c*z-s*x
--~ end

--~ local rad=math.rad

--~ local a=rad(90)

--~ print(rotate({1,0,0},a))
--~ print(rotate({-1,0,0},a))
--~ print(rotate({0,1,0},a))
--~ print(rotate({0,0,1},a))
--~ print(rotate({0,0,-1},a))




--~ local sqrt=math.sqrt
--~ -- return the 2d cross point of a line (x1,y1)->(x2,y2)  and the circle with r=sqrt(r2), centered in (0,0)
--~ local line_cross_circle=function(x1,y1,x2,y2,r2)
--~ 	local t1,t2,t3=x1*x1+y1*y1,x1*x2+y1*y2,x2*x2+y2*y2
--~ 	local a,b,c=t1-t2*2+t3,t3-t2,t3-r2
--~ 	if c>0 then
--~ 		c=sqrt(b*b-a*c)
--~ 		local s1,s2=(b+c)/a,(b-c)/a
--~ 		a=s1>=0 and s1<=1 and s1 or s2
--~ 		b=1-a
--~ 		return a*x1+b*x2,a*y1+b*y2
--~ 	end
--~ end

--~ local get_cross=function(fx,fz,x1,z1,x2,z2,r)
--~ 	x1=x1-fx; z1=z1-fz; x2=x2-fx; z2=z2-fz;
--~ 	local z,x=line_cross_circle(z1,x1,z2,x2,r*r)
--~ 	return x+fx,z+fz
--~ end

--~ print(line_cross_circle(0,0,1,1,1))

--~ print(get_cross(1,0,1,0,0,1,1))


--~ local get_next=function(t,id,n)
--~ 	n=n or #t
--~ 	id=id or 0
--~ 	id= id==n and 1 or id+1
--~ 	if t[id]~=0 then return id end
--~ end

--~ local t={}

--~ local id=get_next(t)
--~ while id do
--~ 	print(id)
--~ 	id=get_next(t,id)
--~ end

--~ local path="/host/Files/BVHPlay/data/bvh/CMU/49_01-walk .bvh"

--~ print(string.match(path,"^.*/%s*(.-)%s*.bvh$"))

--~ local sqrt=math.sqrt
--~ -- return the 2d cross point of a line (x1,y1)->(x2,y2)  and the circle with r=sqrt(r2), centered in (0,0)
--~ local line_cross_circle=function(x1,y1,x2,y2,r2)
--~ 	local t1,t2,t3=x1*x1+y1*y1,x1*x2+y1*y2,x2*x2+y2*y2
--~ 	if t1<r2 and t3<r2 then return end -- two points are all in circle
--~ 	local a,b,c=t1-t2*2+t3,t3-t2,t3-r2
--~ 	t1=b*b-a*c
--~ 	if t1>=0 then -- has solution
--~ 		c=sqrt(t1)
--~ 		local s1,s2=(b+c)/a,(b-c)/a
--~ 		a=s1>=0 and s1<=1 and s1 or s2
--~ 		b=1-a
--~ 		return a*x1+b*x2,a*y1+b*y2
--~ 	end
--~ end

--~ print(line_cross_circle(0,0.5,1,0.5,1))


--~ local sin,cos=math.sin,math.cos
--~ rotate=function(angle,x,y,z) -- rotate a vector around Y axis
--~ 	local c,s=cos(angle),sin(angle)
--~ 	return c*x+s*z,y,c*z-s*x
--~ end

--~ print(rotate(1.57,1,0,1))
--~ print(rotate(1.57,0,0,1))
--~ print(rotate(1.57,1,0,0))
--~ print(rotate(1.57,0,1,0))

--~ local deg=math.deg
--~ local rotate_frame=function(frame,foot,angle) 	-- every frame has ori and angle where real pos=T*R*pose
--~ 	local f={}
--~ 	local rawset=rawset
--~ 	for i,v in ipairs(frame) do
--~ 		rawset(f,i,v)
--~ 	end
--~ 	local x,y,z=rotate(angle,f[1],f[2],f[3])
--~ 	f[1],f[2],f[3]=x+foot[1],y+foot[2],z+foot[3] 	-- update the position of roots
--~ 	print(f[1],f[2],f[3])
--~ 	f.angle=deg(angle);
--~ 	return f
--~ end


--~ local foot={0,0,0}


--~ rotate_frame({1,0,0},{0,0,0},1.57)

--~ get_angle=function(x,z) 	-- calculate the angle from (1,0,) to (x,z) in XOZ plane around Y axis by right hand rule
--~ 	return math.atan2(-z,x)
--~ end

--~ print(get_angle(-1,0))

--~ local sx,sz,dx,dz=0,1,1,0
--~ local angle=get_angle(sx,sz)-get_angle(dx,dz)

--~ print(rotate(angle,dx,0,dz))

--~ local PI=math.pi

--~ local sin,cos=math.sin,math.cos
--~ local rotate2d=function(a,x,y)
--~ 	local c,s=cos(a),sin(a)
--~ 	return x*c-y*s,x*s+y*c
--~ end

--~ print(rotate2d(PI/2,-1,1))

--~ local rotateXYZ=function(az,ay,ax,x,y,z)
--~ 	x,y,z=x or 0, y or 0, z or 1
--~ 	y,z=rotate2d(ax,y,z)
--~ 	z,x=rotate2d(ay,z,x)
--~ 	x,y=rotate2d(az,x,y)
--~ 	return x,y,z
--~ end

--~ print(rotateXYZ(1.7233,-1.1895,13.5554,0,0,1))



