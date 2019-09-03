local AUXLOADER = require "auxLoader"
local MATRIX = require "matrix"

local path = arg[2]
path = string.format("maps/%s.lua", path)

local chunck = love.filesystem.load(path)
local MAP = chunck()
MAP.quads = {}

local blocks = {}
local tilesets = MAP.tilesets[1]

function love.load()

  local format = string.format("maps/%s", tilesets.image)
  img = love.graphics.newImage(format)

  local qtdeTiles = tilesets.tilecount

  for i = 1, qtdeTiles do
    local index = i - 1

    x, y, w, h = AUXLOADER.result(MAP, index)

    blocks[i] = love.graphics.newQuad(x, y, w, h, img:getDimensions())
    x, y = img:getDimensions()

  end
end

function love.draw()

  love.graphics.translate(300, 150)
  love.graphics.scale(0.25, 0.25)
  render()

end

function render()

  love.graphics.setBackgroundColor(MAP.backgroundcolor)
  local x, y, z = 0, 0, 0
  local w, h = MAP.width, MAP.height
  local layers = MAP.layers
  local tilewidth, tileheight = MAP.tilewidth, MAP.tileheight

  for k, layer in ipairs(layers) do

    if(layer.type == "tilelayer") then
      x, y, z = 0, 0, layer.offsety
      for i = 1, h do
        x = 0
        for j = 1, w do

          local data = layer.data[(i - 1) * w + j]

          if(data ~= 0) then
            local transf = MATRIX.linearTransform(x,y,z,tilewidth,tileheight)
            love.graphics.draw(img, blocks[data], transf[1][1], transf[2][1])
          end
          x = x + 1
        end
        y = y + 1
      end

    else -- layer.type == "objectgroup"
      --print("diferente")
      for i, obj in ipairs(layer.objects) do

        local x = math.floor(obj.x  / obj.width)
        local y = math.floor(obj.y / obj.height)

        if(obj.type == "sprite" and obj.visible) then

          for frame_token in obj.properties.frames:gmatch("%d+") do
            local frame = tonumber(frame_token)
          end

          --print("frame=", frame)
          local transf = MATRIX.linearTransform(x,y,z,tilewidth,tileheight)

          love.graphics.draw(img, blocks[148], transf[1][1], transf[2][1])

          print("z=", z, ", name=", obj.name)
        end
      end
      --[[
      x=	2	,y=	5	, z=	-64
      xx=	-166.5	,yy= 	160
      z=	-64	, name=	caverman

      x=	3	,y=	10	, z=	-64
      xx=	-388.5	,yy= 	352
      z=	-64	, name=	turtle-1

      x=	5	,y=	1	, z=	-64
      xx=	222	,yy= 	128
      z=	-64	, name=	caverman

      ]]

    end
  end

end
