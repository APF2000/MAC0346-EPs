--luacheck: globals love

local AUXLOADER = require "auxLoader"
local MATRIX = require "matrix"

local mapName = arg[2]
mapName = AUXLOADER.format("maps", mapName, ".lua")

local chunck = love.filesystem.load(mapName)
local MAP = chunck()
MAP.quads = {}

local blocks = {}
local sprites = {}
local tilesets = MAP.tilesets[1]
local layers = MAP.layers
local imgBlocks

function love.load()

  local formatBlocks = AUXLOADER.format("maps", tilesets.image, "")
  imgBlocks = love.graphics.newImage(formatBlocks)
  local qtdeTiles = tilesets.tilecount

  for i = 1, qtdeTiles do
    local index = i - 1

    local x, y, w, h = AUXLOADER.blocks(MAP, index)

    blocks[i] = love.graphics.newQuad(x, y, w, h, imgBlocks:getDimensions())
  end

  sprites = AUXLOADER.sprites(MAP)

end

local function render()

  love.graphics.setBackgroundColor(MAP.backgroundcolor)
  local x, y, z
  local w, h = MAP.width, MAP.height
  local tilewidth, tileheight = MAP.tilewidth, MAP.tileheight

  for _, layer in ipairs(layers) do

    if(layer.type == "tilelayer") then
      y, z = 0, layer.offsety
      for i = 1, h do
        x = 0
        for j = 1, w do

          local data = layer.data[(i - 1) * w + j]

          if(data ~= 0) then
            local transf = MATRIX.linearTransform(x,y,z,tilewidth,tileheight)
            love.graphics.draw(imgBlocks, blocks[data], transf[1][1], transf[2][1])
          end
          x = x + 1
        end
        y = y + 1
      end

    else
      for _, obj in ipairs(layer.objects) do

        local xobj = math.floor(obj.x  / obj.width)
        local yobj = math.floor(obj.y / obj.height)

        if(obj.type == "sprite" and obj.visible) then

          local transf = MATRIX.linearTransform(xobj,yobj,z,tilewidth,tileheight)
          transf[1][1] = transf[1][1] + obj.properties.offsetx
          transf[2][1] = transf[2][1] + obj.properties.offsety

          local spr = sprites[obj.name]
          local frameVector = obj.properties.frames
          local total = frameVector.total
          local current = frameVector.current % total + 1
          local frameToSet = frameVector[current]

          local flipX = 1
          if obj.properties.flip == true then
            flipX = -1
          end

          love.graphics.draw(spr.img, spr[frameToSet],
            transf[1][1], transf[2][1], 0, flipX, 1)


          obj.newTime = love.timer.getTime()


          if obj.newTime - obj.oldTime >= 1 / obj.properties.fps then

            frameVector.current = current % total

            obj.oldTime = obj.newTime
          end

          else if(obj.type == "camera") then

            love.graphics.push()
            love.graphics.translate(obj.x, obj.y)
            love.graphics.scale(10, 10)
            love.graphics.pop()
          end
        end
      end
    end
  end

end


function love.draw()

  love.graphics.translate(850, 200)
  love.graphics.scale(0.7, 0.7)
  render()

  love.window.setFullscreen(true)
end
