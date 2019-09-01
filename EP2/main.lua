local LOADER = require "auxLoader"

local defaultPath = love.filesystem.getRequirePath()
local path = arg[2]
path = LOADER.addPath(path)
love.filesystem.setRequirePath(path)

local MAP = require (path)


function love.draw()

  love.graphics.setNewFont(20)

  love.graphics.print("Hello world!", 400, 300)

  love.graphics.print(MAP.version, 100, 100)


end
