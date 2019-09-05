--luacheck: globals love

local AUXLOADER = require "auxLoader"
local MATRIX = require "matrix"
local AUXLAYER = require "layer"

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
  local z
  local w, h = MAP.width, MAP.height
  local tilewidth, tileheight = MAP.tilewidth, MAP.tileheight

  for _, layer in ipairs(layers) do

    if(layer.type == "tilelayer") then
      z = AUXLAYER.tilelayer(MAP, h, w, layer, imgBlocks, blocks, MAP)
    else
      for _, obj in ipairs(layer.objects) do

        local xobj = math.floor(obj.x  / obj.width)
        local yobj = math.floor(obj.y / obj.height)

        if(obj.type == "sprite" and obj.visible) then

          local transf = MATRIX.linearTransform(xobj,yobj,z,tilewidth,tileheight)
          AUXLAYER.sprite(obj, transf, sprites)


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
