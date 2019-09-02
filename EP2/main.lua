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
  ---------------------------------------------------------

  local format = string.format("maps/%s", tilesets.image)
  img = love.graphics.newImage(format)

  local qtdeTiles = tilesets.tilecount

  for i = 1, qtdeTiles do
    local index = i - 1

    x, y, w, h = AUXLOADER.result(MAP, index)

    blocks[i] = love.graphics.newQuad(x, y, w, h, img:getDimensions())
    x, y = img:getDimensions()
    --print("dim=", x, y)
  end
end

function love.draw()

  love.graphics.setNewFont(20)

  love.graphics.print("Hello world!", 400, 300)

  -- A funcao draw e executada varias vezes

  --[[x, y, z = 1, 2, 20
  local transf = MATRIX.linearTransform(x, y, z, 111, 64)
  --print("transfxx=", transf[1][1], ", transfyy=", transf[2][1])
  love.graphics.draw(img, blocks[10], transf[1][1], transf[2][1])
  love.graphics.draw(img, blocks[100], 131, 20)
  love.graphics.draw(img, blocks[50], 300, 20)]]

  --love.window.setFullscreen(true)
  love.graphics.translate(400, 200)
  love.graphics.scale(0.3, 0.3)
  render()

  --loadTiledMap(format)
end

function render()

  love.graphics.setBackgroundColor(MAP.backgroundcolor)
  local x, y, z = 0, 0, 0
  local w, h = MAP.width, MAP.height
  local layers = MAP.layers
  local tilewidth, tileheight = MAP.tilewidth, MAP.tileheight

  troll = 0
  for k, layer in ipairs(layers) do
    --if troll >= 3 then break end
    troll = troll + 1
    --print("layer = ", layer, ", k = ", k)
    x, y = 0, 0
    if(layer.type == "tilelayer") then
      x, y, z = 0, 0, layer.offsety
      for i = 1, h do
        x = 0
        for j = 1, w do
          local data = layer.data[(i - 1) * w + j]
          if troll == 2 then print("data = ", data, ", j = ", j, ", i = ", i) end

          if(data ~= 0) then
            local transf = MATRIX.linearTransform(x,y,z,tilewidth,tileheight)
            love.graphics.draw(img, blocks[data], transf[1][1], transf[2][1])
          end
          x = x + 1
        end
        y = y + 1
      end
    else
      --print("diferente")
    end
  end

end


--[[function loadTiledMap(path)
  for y = 0, (tilesets.imageheight / tilesets.tileheight) - 1 do
    for x = 0, (tilesets.imagewidth / tilesets.tilewidth) - 1 do
      local quad = love.graphics.newQuad(
        x * tilesets.tilewidth,
        y * tilesets.tileheight,
        tilesets.tilewidth,
        tilesets.tileheight,
        tilesets.imagewidth,
        tilesets.imageheight
      )
      table.insert(MAP.quads, quad)
    end
  end

  function MAP:draw()
    for i, layer in ipairs(sel.layers) do
      for y = 0, layer.height - 1 do
        for x = 0, layer.width - 1 do
          local index = (x + y * layer.width) + 1
          local tid = layer.data[index]

          if tid ~= 0 then
            local quad = self.quads(tid)
            local xx = x * self.tilesets[1].tilewidth
            local yy = y * self.tilesets[1].tileheight


            love.graphics.draw(
              img,
              quad,
              xx,
              yy
            )
          end

        end
      end
    end
  end

end
]]
