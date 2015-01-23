require 'posix'

local make_pipe=function(cmd,...)
	local r1,w1=posix.pipe()
	assert(r1 and w1, "pipe() failed")
	io.flush()
--~ 	local pid, err = posix.fork()
--~     assert(pid ~= nil, "fork() failed")
	posix.dup(r1,io.stdin)
	posix.dup(w1,io.stdout)
	local ret, err = posix.execp(cmd, unpack({...}))
    assert(ret ~= nil, "execp() failed")
	print(ret)
end

make_pipe"haserl"
