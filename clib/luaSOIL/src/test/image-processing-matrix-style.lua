local soil=require "luaSOIL"

local img2mat=function(img,mat,width,height,req_channels)
	local row,cell
	local row_lenght,pos=width*req_channels
	local get_img=soil.get_img
	for y=1,height do
		row={}
		for x=1,width do
			cell={}
			for i=1,req_channels do
				pos=row_lenght*(y-1)+(x-1)*req_channels
				cell[i]=get_img(img,pos+i-1)
			end
			row[x]=cell
		end
		mat[y]=row
	end
	return mat
end

local create_imgmat=function(width,height,req_channels)
	width,height,req_channels=width or 1,height or 1,req_channels or soil.LOAD_RBG
	local img,channels
	img,width,height,channels=soil.create_img(width,height,req_channels)
	if not img then 
		return print("Can't create image!")
	end
	local mat={width=width,height=height,channels=channels,req_channels=req_channels,img=img}
	return img2mat(img,mat,width,height,req_channels)
end

local imgfile2mat=function(path,req_channels)
	local img,width,height,channels=soil.load_img(path,req_channels)
	if not img then 
		return print("Can't load image from file:",path)
	end
	req_channels=req_channels and req_channels>0 and req_channels or channels
	local mat={width=width,height=height,channels=channels,req_channels=req_channels,img=img}
	return img2mat(img,mat,width,height,req_channels)
end

local mat2img=function(mat,img,width,height,req_channels)
	local set_img=soil.set_img
	local row_lenght,pos=width*req_channels
	for r,row in ipairs(mat) do
		for c,cell in ipairs(row) do
			pos=row_lenght*(r-1)+(c-1)*req_channels
			for i=1,req_channels do
				set_img(img,pos+i-1,cell[i])
			end
		end
	end
	return img
end

local mat2imgfile=function(mat,path,width,height,req_channels)
	local img=mat.img
	img,width,height,req_channels=mat.img, width or mat.width, height or mat.height, req_channels or mat.req_channels
	img=mat2img(mat,img,width,height,req_channels)
	local _,fmt=string.match(path,"^(.*)%.([^/\\]-)$")
	if not fmt then
		fmt="bmp"
		path=path.."."..fmt
	end
	return  soil.save_img(path, soil["SAVE_TYPE_"..string.upper(fmt)],width, height, req_channels,img)
end

--~ local mat=imgfile2mat("/host/Files/lua-platform/data/water.jpeg",soil.LOAD_RGBA)
--~ local mat=create_imgmat(200,200,soil.LOAD_RGBA)

--~ local w,h=mat.width,mat.height

--~ local hw,hh=w/2,h/2

--~ local passed=function(x,y)
--~ 	x,y=x-hw,y-hh
--~ 	return x*x+4*y*y<10000
--~ end

--~ local red={255,0,0,255}

--~ for x=0,w-1 do
--~ 	for y=0,h-1 do
--~ 		if passed(x,y) then
--~ 			mat[y+1][x+1]=red
--~ 		end
--~ 	end
--~ end



local valid_cell=function(cell,background)
	if cell.background then
		return false
	elseif cell.valid then
		return true
	else
		for i,v in ipairs(cell) do
			if v~=background[i] then
				cell.valid=true
				return  true
			end
		end
		cell.background=true
		return false
	end
end

local label_cell=function(cell,r,c,w,h,mat,background) -- label a pixel if it is a inner one
	if valid_cell(cell,background) then
		if r>1 and r<h and c>1 and c<w 
		and valid_cell(mat[r][c-1],background)
		and valid_cell(mat[r][c+1],background)
		and valid_cell(mat[r+1][c],background)
		and valid_cell(mat[r-1][c],background)
		and valid_cell(mat[r+1][c+1],background)
		and valid_cell(mat[r-1][c+1],background)
		and valid_cell(mat[r-1][c-1],background)
		and valid_cell(mat[r+1][c-1],background)
		then 
			cell.inner=true
		else
			cell.outline=true
		end
	end
	return cell
end


local set_color=function(dst,c)
	if c then
		for i,v in ipairs(c) do
			dst[i]=v
		end
	end
	return dst
end

local apply_mat_func=function(mat,func,...)
	for r,row in ipairs(mat) do
		for c,cell in ipairs(row) do
			func(cell,r,c,unpack(arg))
		end
	end
	return mat
end


local set_inner_cell=function(cell,r,c,background)
	if cell.inner then
		set_color(cell,background)
	end
end

local outline=function(mat,background)
	background=background or {0,0,0,0}
	apply_mat_func(mat,label_cell,mat.width,mat.height,mat,background)
	apply_mat_func(mat,set_inner_cell,background)
	return mat
end

local set_outline_cell=function(cell,r,c,background)
	if cell.outline then
		set_color(cell,background)
		cell.background=true
		cell.valid=false
		cell.inner=false
		cell.outline=false
	end
end

local shrink=function(mat,background)
	background=background or {0,0,0,0}
	apply_mat_func(mat,label_cell,mat.width,mat.height,mat,background)
	apply_mat_func(mat,set_outline_cell,background)
	return mat
end

local background={0,0,0}

local mat1=imgfile2mat("/host/Files/lua-platform/data/-HOKU015.JPG",soil.LOAD_RGB)
mat1=outline(mat1,background)
mat2imgfile(mat1,"./outline.tga")


local mat2=imgfile2mat("/host/Files/lua-platform/data/-HOKU015.JPG",soil.LOAD_RGB)
for i=1,2 do
	mat2=shrink(mat2,background)
end
mat2imgfile(mat2,"./shrink.tga")





