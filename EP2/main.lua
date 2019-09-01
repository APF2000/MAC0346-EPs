local AUXLOADER = require "auxLoader"
local path = arg[2]
path = string.format("%s.lua", path)
path = AUXLOADER.format(path)

local MATRIX = require "matrix"

local chunck = love.filesystem.load(path)
local MAP = chunck()

local blockImg = {}

function love.load()
  ---------------------------------------------------------
  img = love.graphics.newImage("maps/tilesheet_complete.png")

  print("MAP = ", MAP)
  local index = 5

  local tilesets = MAP.tilesets[1]

  local columns = tilesets.columns
  local tileH = tilesets.tileheight
  local tileW = tilesets.tilewidth

  local startX = 0
  local startY = 0

  if(index / columns <= 5) then
    startX = tileW * (index % columns)
    startY = tileH * math.floor(index / columns)
  else
    local newIndex = index - columns*5
    startX = tileW * ((newIndex) % 10)
    startY = tileH * math.floor((newIndex) / 10 + 5)
  end

  blockImg = love.graphics.newQuad(startX, startY, tileW, tileH, img:getDimensions())

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

  love.graphics.draw(img, blockImg, 50, 50)

end
