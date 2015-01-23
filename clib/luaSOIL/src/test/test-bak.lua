local soil=require "luaSOIL"

--~ for k,v in pairs(soil) do
--~ 	print(k,v)
--~ end

make_img_funcs=function(img_path,width,height,req_channels)
	local load_img,get_img,set_img,save_img,create_img=soil.load_img,soil.get_img,soil.set_img,soil.save_img,soil.create_img
	local min=math.min
	local img
	local mat,default_color={},{}
	if img_path then
		img,width,height,channels=load_img(img_path,req_channels)
	else
		req_channels=soil.LOAD_RBG -- force the req_channels to RGB, to complicate with normal use
		img,width,height,channels=create_img(width,height,req_channels)
		for i=1,req_channels do default_color[i]=0 end
		local row
		for r=1,height do
			row={}
			for c=1,width do
				row[c]=default_color
			end
			mat[r]=row
		end
	end
	req_channels=req_channels and min(req_channels,channels) or channels
	local row=width*channels
	local get,set,save
	local color={}
	
	
	
	
	
	
	get=function(x,y)
		local pos=row*y+x*channels
		for i=1,req_channels do
			color[i]=get_img(img,pos+i-1)
		end
		return color
	end
	set=function(x,y,c)
		local pos=row*y+x*channels
		for i=1,min(req_channels,#c) do
			set_img(img,pos+i-1,c[i])
		end
		return c
	end
	save=function(path)
		local _,fmt=string.match(path,"^(.*)%.([^/\\]-)$")
		print(fmt)
		if not fmt then
			fmt="bmp"
			path=path.."."..fmt
		end
		return save_img(path, soil["SAVE_TYPE_"..string.upper(fmt)],width, height, req_channels or channels,img)
	end
	
	return get,set,save,width,height,channels,req_channels
end

local get,set,save,w,h,ch,rch=make_img_funcs(nil,800,800)

print(w,h,ch,rch)

local red={255,0,0}

--~ for x=30,w-30 do
--~ 	for y=90,h-90 do
--~ 		set(x,y,red)
--~ 	end
--~ end

local hw,hh=w/2,h/2

local passed=function(x,y)
	x,y=x-hw,y-hh
	return x*x+y*y<40000
end

for x=0,w-1 do
	for y=0,h-1 do
		if passed(x,y) then
			set(x,y,red)
		end
	end
end



--~ local x,y=math.floor(w/2),math.floor(h/2)

--~ set(x,y,red)
--~ set(x+1,y,red)

print(save("./test.bmp"))




