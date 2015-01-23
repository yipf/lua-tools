--~ local str=io.open():read("*a")

local LINE_PAT="^%s*()(%S+)(.-)$"

local trim=function(str)
	return str:match("^%s*(.-)%s*$")
end

local KV_PAT="^%s*(.-)%s+:%s+(.-)%s*$"
local EMPTY_PAT="^%s*$"

local str2arrays=function(str,sep)
	sep=sep or "\n"
	local lines={}
	local push=table.insert
	for line in (str..sep):gmatch("(.-)"..sep) do
		push(lines,line)
	end
	return lines
end

local in_set=function(a,t)
	for i,v in ipairs(t) do
		if a==v then return true
	end
end

local LIST_TYPES={"OL","UL"}

local ps={
	['^@(.-)$']="PROPS", ['^%**()$']='SEC',['^#BEGIN_(.-)$']='BLOCK',
}
local first_match=function(str,ps)
	local m
	for k,v in pairs(ps) do
		m=str:match(k)
		if m then return m,v
	end
end

local register_block=function(blocks,tp,label,block)
	local dst=rawget(t,t)
	if not dst then dst={}; rawset(t,tp,dst); end
	table.insert(dst,value); rawset(dst,label,value);
	return t
end

local lines2tree_
lines2tree_=function(lines,s,tree)
	s=s or 1
	tree=tree or {LEVEL=0}
	local len=#lines
	
	local top=tree
	local stack,blocks={top},blocks
	local push,pop,rawget,rawset,match=table.insert,table.remove,rawget,rawset,string.match
	local line,spaces,tag,content,key,value,block,caption,label
	
	while s<=len do
		line=rawget(lines,s)
		s=s+1
		top=rawget(stack,#stack)
		if match(line,EMPTY_PAT) then -- if it is an empty line
			while in_set(top.TYPE,LIST_TYPES) do top=pop(stack) end    -- end a list block
			if top.TYPE=="P" then pop(stack) end -- end a paragraph
		else
			spaces,tag,content=match(line,LINE_PAT)
			if spaces==1 then -- for lines leaded by no space symbols
				key,value=first_match(tag,ps)
				if value=='PROPS' then rawset(top,key,content) 
				elseif value=='BLOCK' then -- if lead a block
					caption,label=match(content,KV_PAT)
					caption=caption or trim(content)
					label=label or caption
					key=key:upper()
					block={TYPE=key,CAPTION=caption,LABEL=label}
					register_block(blocks,key,label,block) -- register to *key* section of blocks 
					while s<=len do 
						line=rawget(lines,s); s=s+1; 
						if line:match("^#END") then  break;  else push(block,line) end 
					end
					while top.TYPE~='SEC' do top=pop(stack) end; push(stack,top) -- find the nearest section 
					push(top,block)
				elseif value=='SEC' then -- if leads a section
					caption,label=match(content,KV_PAT)
					caption=caption or trim(content)
					label=label or caption
					block={TYPE="SEC",LEVEL=key,CAPTION=caption,LABEL=label}
					register_block(blocks,"SEC",label,block)  -- register to "SEC" section of blocks 
					while top.TYPE~='SEC' do top=pop(stack) end
					while top.LEVEL>=key do top=pop(stack) end   
					push(stack,top)
					push(top,block)
					push(stack,block)
				end
			end
--~ 			if normal then  -- treat as normal lines
--~ 				if top.TYPE=="SEC" then top={TYPE="P"}; push(stack,top) end
--~ 				push(top,line)
--~ 			end
		end
	end
	return tree,blocks
end

local REPLACE_PAT="@(.-)@"

local convert_=function(obj,ft)
	local t=obj.TYPE
	if t =="SEC" then obj.TYPE=string.rep("SUB",obj.LEVEL-1)..t end
	local f=rawget(ft,obj.TYPE)
	local t=type(f)
	return t=="function" and f(obj,ft) or t=="string" and f:gsub(REPLACE_PAT,obj) or string.format("[[No handle for %q!]]",obj.TYPE) 
end

local tree2str_
tree2str_=function(tree,ft)
	local rawset,type,tostring=rawset,type,tostring
	for i,v in ipairs(tree) do
		rawset(tree,i,type(v)=='table' and tree2str_(v,ft) or tostring(v) )
	end
	tree.VALUE=table.concat(tree)
	return convert_(tree,ft)
end

local str=[[
 afas a fa
 fa f asf 
 asdf a f

 asdfasdf af a
]]

local lines=str2arrays(str)

for i,v in ipairs(lines) do
	print(i,v)
end