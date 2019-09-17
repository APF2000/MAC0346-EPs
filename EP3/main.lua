local newVec = require "common/vec"
local v2 = newVec()
local v1 = newVec()

v1:_init(1, 1)
v2:_init(1, 2)

print(v1:__tostring())
print(v2:__tostring())

print(v2:dot(v1))
