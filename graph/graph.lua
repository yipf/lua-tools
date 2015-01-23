
make_graph=function(n)
	local W={}
	local rawset,rawget=rawset,rawget
	for i=1,n do rawset(W,i,{}) end
	local ws
	return function(s,e,weight)
		if not s then return n end 
		ws=rawget(W,s)
		if not e then return ws end
		if not weight then return ws and rawget(ws,e) end
		if ws and e<=n then rawset(ws,e,weight); return e end
	end,W
end

local id=function(o) return "n"..tostring(o) end

print_graph=function(G,f)
	f=f or id
	local n=G()
	-- print nodes
	local t={}
	local rawset,rawget=rawset,rawget
	for i=1,n do
		rawset(t,i,f(i))
	end
	print( "{"..table.concat(t,",").."}")
	-- print edges
	local es
	for i=1,n do
		es=G(i)
		if next(es) then -- if es is not empty
			print("Edges for:",rawget(t,i))
			for k,v in pairs(es) do
				print(rawget(t,i),"->",rawget(t,k),":",v)
			end
		end
	end
end


dofile "/home/yipf1/LUA/config.lua"

require "ioio"

local EDGE_FMT="%s->%s [label=%q];"
local GRAPH_FMT="digraph G {\nrankdir=LR;\n%s\n}"
local DOT_FMT="dot -T%s -O %q"
draw_graph=function(G,name,f,op)
	name=name or "graph"
	op=op or "png"
	f=f or id
	local n=G()
	local t={}
	local push,format=table.insert,string.format
	local EDGE_FMT=EDGE_FMT
	for i=1,n do
		for k,v in pairs(G(i)) do
			push(t,format(EDGE_FMT,f(i),f(k),tostring(v)))
		end
	end
	local dot_file=str2file(format(GRAPH_FMT,table.concat(t,"\n")),name..".dot")
	os.execute(format(DOT_FMT,op,dot_file))
end

-- generate subgraph from subset of vertex V from G,   SG <-> refs <-> G
sub_graph=function(V,G)
	local ref={}
	local SG=make_graph(#V)
	local rawget,rawset=rawget,rawset
	for i,v in ipairs(V) do
		rawset(ref,v,i)
	end
	local new_id
	for i,v in ipairs(V) do
		print(i,"as",v)
		for to,e in pairs(G(v)) do
			id=ref[to]
			print(id)
			if id then SG(i,id,e) end -- if the node is in set of sub vertex
		end
	end
	return SG,ref
end


-- test

--~ local G=make_graph(6)

--~ G(1,2,1)
--~ G(1,3,1)
--~ G(2,4,1)
--~ G(3,4,1)
--~ G(3,5,1)
--~ G(4,6,1)
--~ G(4,1,1)
--~ G(5,6,1)

--~ print_graph(G)
--~ draw_graph(G)

--~ require "floyd"

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
--~ G(8,10,2)
--~ G(8,6,2)
--~ G(9,7,2)
--~ G(10,9,1)



--~ draw_graph(G,"floyd")

--~ local D,N=floyd(G)

--~ local path=floyd_shortest_path(1,3,D,N)

--~ print(table.concat(path," -> "))