local Vec = require "common/vec"
local v2 = require "common/vec"
--local v1 = Vec_init(1,1)

--v1:_init(1, 1)
v2:_init(1, 2)

--print(v1:__tostring())
print(v2:__tostring())

print(v2:dot(v2))
