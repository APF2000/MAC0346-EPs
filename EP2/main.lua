local AUXLOADER = require "auxLoader"
local path = arg[2]
path = AUXLOADER.formatLua(path)

local chunck = love.filesystem.load(path)
local MAP = chunck()


function love.load()
  love.filesystem.setRequirePath(path)
  print(love.filesystem.getRequirePath())

  local aux = AUXLOADER.formatImage(MAP.tilesets[1].image)
  --local image = love.filesystem.load("tilesheet_complete.png")

  image = love.graphics.newImage(aux)
end

function love.draw()

  love.graphics.setNewFont(20)

  love.graphics.print("Hello world!", 400, 300)

  love.graphics.print(MAP.version, 100, 100)

  love.graphics.draw(image, 0, 0)

end
