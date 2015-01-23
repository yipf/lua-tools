
require "3D/coordinate"

local build_XYZ,v3d2v3d=build_XYZ,v3d2v3d

make_camera=function (tp,x,y,z,fov,wh,near,far)

	x=x or 0
	y=y or 0
	z=z or 0
	
	fov=fov or 45
	wh=wh or 1
	near=near or 0.1
	far=far or 1000
	
	local ux,uy,uz,dx,dy,dz,scale,h,v=0,1,0,0,0,1,100,0,0

	local lookat,perspective=glu.LookAt,glu.Perspective
	local sin,cos,rad,tan=math.sin,math.cos,math.rad,math.tan
	
	local ft={
		rotate=function (dh,dv)
			h=dh and h+dh
			v=dv and v+dv
			-- regular angles
--~ 			while h>360 do h=h-360 end
--~ 			while h<-360 do h=h+360 end
--~ 			v=v>89 and 89 or v<-89 and -89 or v
			-- compute
			dh=rad(h)
			dv=rad(v)
			local hc,hs,vc,vs=cos(dh),sin(dh),cos(dv),sin(dv)
			dx,dy,dz=hs*vc,vs,hc*vc
			ux,uy,uz=-hs*vs,vc,-hc*vs
		end,
		scale=function (s)
			scale=s and scale*s or scale
		end,
		rate=function (wh_)
			wh=wh_ and wh_ or wh
		end,
		front=function (dis)
			dis=dis and dis*scale or 0
			x=x-dis*dx
			z=z-dis*dz
		end,
		left=function (dis)
			dis=dis and dis*scale or 0
			x=x-dis*dz
			z=z+dis*dx
		end,
		up=function (dis)
			dis=dis and dis*scale or 0
			y=y+dis
		end,
		xy2line=function(winx,winy,w_h)
			local eye={x+scale*dx,y+scale*dy,z+scale*dz} -- get the position of eye
			-- calculate the relative cordinates in the camera system, at a plane whose distance is 1 off the position of camera
			local vfactor=2*math.tan(math.rad(fov*0.5))
			local hfactor=vfactor*w_h
			-- centerize
			winx=(winx-0.5)*hfactor
			winy=(0.5-winy)*vfactor
			local X,Y,Z=build_XYZ(v3d_cross({ux,uy,uz},{dx,dy,dz}),nil,{dx,dy,dz})
			local v=v3d2v3d({winx,winy,-1},X,Y,Z)
			return eye,v3d2v3d({winx,winy,-1},X,Y,Z)
		end,
		xyz2xy=function(x,y,z,winx,winy,w_h)
			
		end,
	}
	if tp=='fps' then
		return function(op,...)
			if not op then
				perspective(fov,wh,near,far)
				lookat(x,y,z,x-scale*dx,y-scale*dy,z-scale*dz,ux,uy,uz)
				return x,y,z
			end
			op=rawget(ft,op)
			if op then
				return op(...)
			end
		end
	else 
		return function(op,...)
			if not op then
				perspective(fov,wh,near,far)
				lookat(x+scale*dx,y+scale*dy,z+scale*dz,x,y,z,ux,uy,uz)
				return x,y,z
			end
			op=rawget(ft,op)
			if op then
				return op(...)
			end
		end
	end
end 