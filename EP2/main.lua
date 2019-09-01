local AUXLOADER = require "auxLoader"
local MATRIX = require "matrix"

local path = arg[2]
path = string.format("maps/%s.lua", path)

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
  --love.filesystem.setRequirePath(path)
  --love.window.setFullscreen(true)

end

function love.draw()

  love.graphics.setNewFont(20)

  love.graphics.print("Hello world!", 400, 300)

  love.graphics.setBackgroundColor(MAP.backgroundcolor)

  --love.graphics.print(MAP.version, 100, 100)

  --love.graphics.draw(image, 0, 0)

  local x, y, z = 0, 0, 0
  local w, h = MAP.width, MAP.height
  local layers = MAP.layers

  for i, layer in ipairs(layers) do
    print("layer = ", layer, ", i = ", i)

    if(layer.type == "tilelayer") then
      for j = 1, w * h - 1 do

        print("data = ", data, ", j = ", j)
        local data = layer.data[j]
        if(data ~= 0) then
          love.graphics.draw(img, blocks[data], 0, 0)
        end


      end
    else
      print("diferente")
    end
  end

end
