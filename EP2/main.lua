local path = arg[2]
path = string.format("maps/%s.lua", path)

local chunck = love.filesystem.load(path)
local MAP = chunck()

function love.draw()

  love.graphics.setNewFont(20)

  love.graphics.print("Hello world!", 400, 300)

  love.graphics.print(MAP.version, 100, 100)


end
