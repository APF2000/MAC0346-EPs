local AUXLOADER = require "auxLoader"
local path = arg[2]
path = string.format("%s.lua", path)
path = AUXLOADER.format(path)

local MATRIX = require "matrix"

local chunck = love.filesystem.load(path)
local MAP = chunck()

local blocks = {}

function love.load()
  ---------------------------------------------------------
  local tilesets = MAP.tilesets[1]
  local format = string.format("maps/%s", tilesets.image)
  img = love.graphics.newImage(format)

  local qtdeTiles = tilesets.tilecount

  for i = 1, qtdeTiles do
    local index = i - 1

    x, y, w, h = AUXLOADER.result(MAP, index)

    blocks[i] = love.graphics.newQuad(x, y, w, h, img:getDimensions())
  end
  --------------------------------------------------------------
  love.filesystem.setRequirePath(path)

  --local layer = MAP.layers[1]
  --local block = layer.data[1]
  --local aux = AUXLOADER.format()
  --image = love.graphics.newImage(aux)
end

function love.draw()

  love.graphics.setNewFont(20)

  love.graphics.print("Hello world!", 400, 300)

  love.graphics.setBackgroundColor(MAP.backgroundcolor)

  --love.graphics.print(MAP.version, 100, 100)

  --love.graphics.draw(image, 0, 0)

  love.graphics.draw(img, blocks[100], 50, 50)

end
