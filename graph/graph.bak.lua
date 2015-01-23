-- vertex can *NOT* be a number'
local make_vertex_func=function(V,E)
	local rawset=rawset
	local v
	return function(vertex)
		if not vertex then return V end
		v=rawget(V,vertex)
		if v then return v end
		rawset(V,vertex,vertex)
		rawset(E,vertex,{})
		return vertex
	end
end

local make_edge_func=function(V,E)
	local rawget,rawset=rawget,rawset
	local es,e
	return function(from,to,weight,edge)
		if not from then return E end
		es=rawget(E,from)
		if not es then print("No existing source node:",from) return end
		if not rawget(V,to) then print("No existing desitnation node:",to); return end
		if not to then return es end
		if not weight then return rawget(es,to) end
		rawset(es,to,{weight,edge})
		return 
	end
end

make_graph=function()
	local V,E={},{}
	return {make_vertex_func(V,E),make_edge_func(V,E)}
end

--- print function for debug

local id=function(n)
	return n
end

print_graph=function(G,show_edges,str_f)
	local V,E=unpack(G)
	V=V(); E=E();
	str_f=str_f or id
	local push=table.insert
	-- print nodes
	local t={}
	for k,v in pairs(V) do
		push(t,str_f(v))
	end
	print( "{"..table.concat(t,",").."}")
	-- print edges
	local name
	if show_edges then
		for from,v in pairs(V) do
			name=str_f(v)
			print("Edges of",name)
			for to,w in pairs(E[from]) do
				v=V[to]
				print(name,"->",str_f(v),":",w[1])
			end			
		end
	end
end

-- test

--~ local G=make_graph()

--~ local V,E=unpack(G)

--~ local n1=V("n1")
--~ local n2=V("n2")
--~ local n3=V("n3")
--~ local n4=V("n4")
--~ local n5=V("n5")
--~ local n6=V("n6")

--~ E(n1,n2,4)
--~ E(n2,n3,5)
--~ E(n2,n4,8)
--~ E(n2,n6,4)

--~ print_graph(G,true)

make_graph=function()
	local V,E={},{}
	local rawset,rawget=rawset,rawget
	local t
	return function(a,b,c,d)
		if not a then return V,E end 
		if not c then 
			b=b or a
			t=rawget(V,a)
			rawset(V,a,b)
			if not t then rawset(E,a,{}) end
			return a
		end
		t=rawget(E,a)
		if not t then return end -- no source node
		if not rawget(V,b) then return end -- no destination node
		rawset(t,b,{c,d})
		return c
	end
end

local id=function(o) return tostring(o) end

print_graph=function(G,f)
	f=f or id
	local V,E=G()
	local t={}
	-- print nodes
	local push=table.insert
	for k,v in pairs(V) do
		push(t,k)
	end
	print( "{"..table.concat(t,",").."}")
	-- print edges
	for from,v in pairs(E) do
		if next(v) then -- not empty
			name=f(V[to])
			print("Edges of",name)
			for to,w in pairs(v) do
				v=V[to]
				print(name,"->",str_f(v),":",w[1])
			end		
		end
	end
end



