f = io.open("input.txt","r")
io.input(f)
local contents = io.read("*all")
io.close(f)
return contents