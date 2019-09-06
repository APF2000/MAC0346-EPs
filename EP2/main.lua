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
  camQuant = table.getn(cameras)

  love.graphics.setBackgroundColor(MAP.backgroundcolor)
end

local current = 1
local camQuant
local camCurrent
local Xprev, Yprev
local Xctrl, Yctrl = 0, 0
function love.update(dt)
  camCurrent = cameras[tostring(current)]
  Xprev, Yprev = camCurrent.x, camCurrent.y

--  print("current", current)
  if(Xnext == nil or camCurrent == nil) then
    return
  end

  if (Xnext >= Xprev  and Xnext < Xctrl and Xprev > Xctrl)
    or (Xprev < Xnext and Xnext < Xprev and Xnext > Xctrl)
    or (Ynext >= Yprev and Ynext < Yctrl and Yprev > Yctrl)
    or (Yprev < Ynext and Ynext < Yprev and Ynext > Yctrl)
      then
    current = (current % camQuant) + 1
    camCurrent = cameras[tostring(current)]
    Xnext = camCurrent.x
    Ynext = camCurrent.y
    Xctrl, Yctrl = Xprev, Yprev
  else
    local alpha = 2
    local dx = (-Xprev + Xnext) / alpha
    local dy = (-Yprev + Ynext) / alpha

    Xctrl = Xctrl + dx
    Yctrl = Yctrl + dy
  end
end

local function render()
  local z
  local w, h = MAP.width, MAP.height

    love.graphics.translate(Xctrl, Yctrl)

    for _, layer in ipairs(layers) do

      if(layer.type == "tilelayer") then
        z = AUXLAYER.tilelayer(MAP, h, w, layer, imgBlocks, blocks, MAP)
      else
        for _, spr in ipairs(sprites) do
          AUXLAYER.sprite(MAP, spr, spriteQuads, layer, z)
        end
      end

    end
end

function love.draw()

  love.graphics.translate(350, 50)
  love.graphics.scale(0.7, 0.7)
  render()

  --love.window.setFullscreen(true)
end
