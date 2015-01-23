--~ http://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm

-- G= {V,E}
-- V={id1,id2,id3,...}
-- E= matrix where E[i][j]=weight from i->j

local INDEX=0
local index={}
local lowlink={}
local stack={}
local NS={}

local push,pop=table.insert,table.remove

local instack=function(a)
	for i,v in ipairs(stack) do
		if v==a then return true end
	end
end

local min=function(a,b)
	return a<b and a or b
end

local tarjan
tarjan=function(v,G)
	index[v]=INDEX
	lowlink[v]=INDEX
	INDEX=INDEX+1
	push(stack,v)
	local es=G(v)
	if next(es) then
		for w,e in pairs(es) do
			if not index[w] then 
				tarjan(w,G)
				lowlink[v] = min(lowlink[v],lowlink[w])
			elseif instack(w) then
				lowlink[v] = min(lowlink[v], index[w])
			end
		end
	end
	local w
	if lowlink[v]==index[v] then 
		local S={}
		repeat
			w=pop(stack)
			push(S,w)
		until v==w
		push(NS,S)
	end
end

get_scc=function(G)
	stack={}
	INDEX=0
	index={}
	lowlink={}
	NS={}
	local n=G()
	for i=1,n do
		if not index[i] then
			tarjan(i,G)
		end
	end
	return NS
end



--= test 

--~ require "graph"

--~ local G=make_graph(10)

--~ G(1,2,1)
--~ G(1,3,1)
--~ G(2,4,1)
--~ G(3,4,1)
--~ G(3,5,1)
--~ G(4,6,1)
--~ G(4,1,1)
--~ G(5,6,1)
--~ G(10,9,1)
--~ G(9,10,1)
--~ local scc=get_scc(G)

--~ for i,v in ipairs(scc) do
--~ 	print(i,"{"..table.concat(v,",").."}")
--~ end



