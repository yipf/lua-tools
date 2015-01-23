--~ http://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm

local HUGE=math.huge

floyd=function(G)
	local D,N={},{}
	local n=G()
	local rawset,rawget=rawset,rawget
	local ds
	-- init
	for i=1,n do
		ds={}
		ns={}
		for j=1,n do
			rawset(ds,j,i==j and 0 or G(i,j) or HUGE)
		end
		rawset(D,i,ds)
		rawset(N,i,ns)
	end
	-- update  the distance matrix D
	local d
	for k=1,n do
		for i=1,n do
			for j=1,n do
				d=D[i][k] + D[k][j]
				if d < D[i][j] then D[i][j] = d; N[i][j]=k; end
			end
		end
	end
	return D,N
end

local path_combine=function(t1,t2)
	local t={}
	local push,rawget=table.insert,rawget
	for i=1,#t1-1 do push(t,rawget(t1,i)) end
	for i,v in ipairs(t2) do push(t,v) end
	return t
end

local shortest_path
shortest_path=function(i,j,D,N)
	local path={}
	if D[i][j]==HUGE then return path end -- no path from i -> j
	local k=N[i][j]
	if not k then return {i,j} end
	return path_combine(shortest_path(i,k,D,N),shortest_path(k,j,D,N))
end

floyd_shortest_path=shortest_path

-- test 

--~ require "graph"

--~ local G=make_graph(10)

--~ G(1,2,2)


--~ G(1,4,20)
--~ G(2,5,1)
--~ G(3,1,3)
--~ G(4,3,8)
--~ G(4,6,6)
--~ G(4,7,4)
--~ G(5,3,7)
--~ G(5,8,3)
--~ G(6,3,1)
--~ G(7,8,1)
--~ G(8,6,2)
--~ G(8,10,2)
--~ G(9,7,2)
--~ G(10,9,1)

--~ draw_graph(G,"floyd")

--~ local D,N=floyd(G)

--~ local path=shortest_path(1,3,D,N)

--~ print(table.concat(path," -> "))