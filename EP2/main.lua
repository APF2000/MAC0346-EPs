local AUXLOADER = require "auxLoader"
local MATRIX = require "matrix"

local mapName = arg[2]
mapName = AUXLOADER.format("maps", mapName, ".lua")
path = string.format("maps/%s.lua", path)

local chunck = love.filesystem.load(mapName)
local MAP = chunck()
MAP.quads = {}

local blocks = {}
local sprites = {}
local tilesets = MAP.tilesets[1]
local layers = MAP.layers

function love.load()

  local formatBlocks = AUXLOADER.format("maps", tilesets.image, "")
  imgBlocks = love.graphics.newImage(formatBlocks)
  local qtdeTiles = tilesets.tilecount

  for i = 1, qtdeTiles do
    local index = i - 1

    x, y, w, h = AUXLOADER.blocks(MAP, index)

    blocks[i] = love.graphics.newQuad(x, y, w, h, imgBlocks:getDimensions())
    x, y = imgBlocks:getDimensions()
  end

  sprites = AUXLOADER.sprites(MAP)
  --[[print("sprites", sprites["caverman"])
  print("sprites", sprites["caverman"][1])]]

  --print("imgsprites", imgSprites)
  --print("imgblocks", imgBlocks)

  for i=1, 1 do end
  --sprites[i] = love.graphics.newQuad(x, y, w, h, imgSprite:getDimensions())
  --x, y = imgSprite:getDimensions()
end

function love.draw()

  love.graphics.translate(300, 100)
  love.graphics.scale(0.6, 0.6)
  render()

end

local frameCounter = 1
local FPS = 1
function love.update(dt)
  if dt > 1 / FPS then
    frameCounter = frameCounter % FPS + 1
  end
end

function render()

  print("\ntaoquei")

  love.graphics.setBackgroundColor(MAP.backgroundcolor)
  local x, y, z = 0, 0, 0
  local w, h = MAP.width, MAP.height
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
            love.graphics.draw(imgBlocks, blocks[data], transf[1][1], transf[2][1])
          end
          x = x + 1
        end
        y = y + 1
      end

    else
      for i, obj in ipairs(layer.objects) do

        local x = math.floor(obj.x  / obj.width)
        local y = math.floor(obj.y / obj.height)

        if(obj.type == "sprite" and obj.visible) then

          local transf = MATRIX.linearTransform(x,y,z,tilewidth,tileheight)

          local spr = sprites[obj.name]
          local frameVector = obj.properties.frames
          local total = frameVector.total
          local current = frameVector.current % total + 1
          local frameToSet = frameVector[current]

          print("\ntotal - name", total, obj.name)
          print("current", current)
          print('frameToSet', frameToSet)

          love.graphics.draw(spr.img, spr[frameToSet], transf[1][1], transf[2][1])

          if frameCounter == FPS then
            frameVector.current = current % total

            print("framevec=", frameVector)
            print("current=", frameVector.current)
          end

        end
      end

    end
  end

end
