local LOADER = require "loader"
local mapPath = ...

LOADER.addPath(mapPath)
print(package.path)
local MAP = require "maps/test.lua"

print(MAP)
print(MAP.tilesets[1].name)
print(MAP.version)

--[[for i, obj in ipairs(MAP) do
  print(MAP[i])
end]]

--local scenario = LOADER.
