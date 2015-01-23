
local make_cell_func=function(value)
	value=value or 0
	if type(value)=="function" then
		return value
	end
	return function(i,j)
		return value
	end
end

local make_matrix=function(row,col,value)
	local m,r={}
	row,col,value=row or 1,col or 1,make_cell_func(value)
	for i=1,row do
		r={}
		for j=1,col do
			r[j]=value(i,j)
		end
		m[i]=r
	end
	return m
end

local copy_matrix=function(m)
	if not m then return m end
	local dst,row=dst or {},row
	for i,r in ipairs(m) do
		row={}
		for j,c in ipairs(r) do
			row[j]=c
		end
		dst[i]=row
	end
	return dst
end

local get_column=function(m,col)
	local c={}
	for i,v in ipairs(m) do
		c[i]=v[col]
	end
	return c
end

local transpose=function(m)
	local mm={}
	for i=1,#m[1] do
		mm[i]=get_column(m,i)
	end
	return mm
end

local dot=function(v1,v2)
	if #v1~=#v2 then  return print"Vectors must have the same number of elements!" end
	local sum=0
	for i,v in ipairs(v1) do
		sum=sum+v*v2[i]
	end
	return sum
end

local multiple=function(m1,m2)
	local mm,m2t,rr={},transpose(m2)
	for i,r in ipairs(m1) do
		rr={}
		for j,c in ipairs() do
			rr[j]=dot(r,c)
		end
		mm[i]=rr
	end
	return mm
end

local mult_row=function(r,a)
	for i,v in ipairs(r) do
		r[i]=v*a
	end
	return r
end

local add_row=function(r,r1,a)
	for i,v in ipairs(r) do
		r[i]=v+r1[i]*a
	end
	return r
end

local abs=math.abs

local GaussJordan -- Gauss-Jordan main loop       ---------------   http://blog.csdn.net/hopeyouknow/article/details/6277145
GaussJordan=function(m,id,rows,cols) 
	local max_cell,mi,mj,cell=0
	-- find max value and record its row number and col number
	for i,r in ipairs(m) do
		if not r.order then -- if not processed 
			for j=1,cols do
				cell=abs(m[i][j])
				if cell>=max_cell then
					max_cell=cell
					mi,mj=i,j
				end
			end
		end
	end
	-- eliminate the prime, manipulate 'm' and 'id' synchronously
	if not mi then return id end -- every rows are processed
	if max_cell==0 then print"No valid inverse for this matrix!"; return end -- prime cell is 0
	local mr,ir=m[mi],id[mi]
	mr.order=mj; ir.order=mj;
	cell=mr[mj]
	mult_row(mr,1/cell);  mult_row(ir,1/cell);
	for i=1,rows do
		if i~=mi then cell=-m[i][mj]; add_row(m[i],mr,cell); add_row(id[i],ir,cell); end
	end
	return GaussJordan(m,id,rows,cols)
end

local id_f=function(i,j)
	return i==j and 1 or 0
end

local swap_rows=function(m,a,b)
	if a~=b then
		local r=m[b]
		m[b]=m[a]; m[a]=r;
	end
	return m
end

local GaussJordan_inverse=function(m)
	local rows,cols=#m,#m[1]
	local id=make_matrix(rows,cols,id_f)
	local swap_rows=swap_rows
	id=GaussJordan(copy_matrix(m),id,rows,cols)
	if not id then return end
	local ir
	for i=1,rows do
		ir=id[i].order
		while ir~=i do
			swap_rows(id,i,ir)
			ir=id[i].order
		end
	end
	return id
end

print_matrix=function(m,des)
	if not m then return  end
	print(des or "matrix:",#m.."x"..#m[1])
	local concat=table.concat
	for i,v in ipairs(m) do
		print(concat(v,"\t"))
	end
	return m
end

local m=make_matrix(10,10,id_f)

m[1][3]=2
m[2][3]=2
m[3][3]=0

print_matrix(m,"Original matrix:")

local im=GaussJordan_inverse(m)

print_matrix(im,"Inverse matrix of 'm':")