--luacheck: globals love

local AUXLOADER = require "auxLoader"
local AUXLAYER = require "auxlayer"

local mapName = arg[2]
mapName = AUXLOADER.format("maps", mapName, ".lua")

local chunck = love.filesystem.load(mapName)
local MAP = chunck()

local blocks = {}
local spriteQuads = {}
local sprites = {}
local cameras = {}
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

  spriteQuads = AUXLOADER.spriteQuads(MAP)
  sprites, cameras = AUXLOADER.objects(layers)

  love.graphics.setBackgroundColor(MAP.backgroundcolor)
end

local function render()
  local z
  local w, h = MAP.width, MAP.height

  --[[for _, layer in ipairs(layers) do
    if layer.type == "tilelayer" then
      z = AUXLAYER.tilelayer(MAP, h, w, layer, imgBlocks, blocks, MAP)
    end
  end

  for _, spr in ipairs(sprites) do
    AUXLAYER.sprite(MAP, spr, spriteQuads, z)
  end]]

  for _, layer in ipairs(layers) do

    if(layer.type == "tilelayer") then
      z = AUXLAYER.tilelayer(MAP, h, w, layer, imgBlocks, blocks, MAP)
    else
      for _, spr in ipairs(sprites) do
        AUXLAYER.sprite(MAP, spr, spriteQuads, layer, z)
      end
      --[[for _, obj in ipairs(layer.objects) do
        if(obj.type == "sprite" and obj.visible) then
          AUXLAYER.sprite(MAP, obj, spriteQuads, z)

        elseif(obj.type == "camera") then
          AUXLAYER.camera(obj)
        end
      end]]
    end

  end
end

function love.draw()

  love.graphics.translate(850, 200)
  love.graphics.scale(0.7, 0.7)
  render()

  love.window.setFullscreen(true)
end
