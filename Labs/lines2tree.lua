
local TOC_PAT="^%*+()%s*(.-)%s*$"
local CONTENT_LABEL_PAT="^(.*%S)%s+:%s+(.-)$"
local push,pop,rawget,rawset,match=table.insert,table.remove,rawget,rawset,string.match

local TYPE_STR

local trim=function(str) return match(str,"^%s*(.-)%s*$") end
local not_empty=function (str) return match(str,"%S") end 

local file2toc
lines2toc=function(lines,s,e,t,base_level)
	t=t or {}
	base_level=base_level or 0
	local stack={t}
	s=s or 1
	e=e or #lines
	local line,level,value,label
	repeat
		line=rawget(lines,s)
		level,value=match(line,TOC_PAT)
		if level then
			while #stack>level do pop(stack) end
			if not_empty(value) then
				line,label=match(value,CONTENT_LABEL_PAT)
				value=line or value
				label=label or value
				
			end
		else
			push(stack(#stack),line)
		end
		s=s+1
	until s>e
	local line=rawget(lines,s)
	spaces,tag,level,value=match(line,TOC_PAT)
	if not tag then -- if empty line 
		if block then push(t,block); block=nil; end
	else
		
	end
end

local LINE_PAT="^%s*()(%S+)(.-)%s*$"
local TOC_PAT="^%*+()$"
local PROP_PAT="^@(.-)$"
local BLOCK_PAT="^#BEGIN_(.-)$"

lines2tree=function(lines,tree,s,e)
	local line,space,tag,key,content
	repeat
		line=rawget(lines,s)
		s=s+1
		if line then
			space,tag,content=match(line,LINE_PAT)
			if tag then -- not empty line
				if space==1	then -- special : toc lines, prop lines or block lines, ...
					space,tag=match(tag,PROP_PAT)
				else 
				end
			end
		end
	until s>e
	return tree,s
end


local str=" : : asdfsdaf  asdfasdfa"

local s={match(str,CONTENT_LABEL)}

print(table.concat(s,"||||"))