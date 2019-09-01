local path = arg[2]
path = string.format("maps/maps/%s.lua", path)

love.filesystem.setRequirePath(path)
print(love.filesystem.getRequirePath())

local chunck = love.filesystem.load(path)
local MAP = chunck()


function love.load()
  --image = love.graphics.newImage(MAP.tilesets[1].image)
end

function love.draw()

  love.graphics.setNewFont(20)

  love.graphics.print("Hello world!", 400, 300)

  love.graphics.print(MAP.version, 100, 100)

  --love.graphics.draw(image, 0, 0)

end
