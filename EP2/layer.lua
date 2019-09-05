-- luacheck: globals love
local AUXLAYER = {}
local MATRIX = require "matrix"

function AUXLAYER.tilelayer(MAP, height, width, layer, img, blocks)
  local y, z = 0, layer.offsety
  local tilewidth, tileheight = MAP.tilewidth, MAP.tileheight
  for i = 1, height do
    local x = 0
    for j = 1, width do
      local data = layer.data[(i - 1) * width + j]
      if(data ~= 0) then
        local transf = MATRIX.linearTransform(x,y,z,tilewidth,tileheight)
        love.graphics.draw(img, blocks[data], transf[1][1], transf[2][1])
      end
      x = x + 1
    end
    y = y + 1
  end
  return z
end

function AUXLAYER.sprite(obj, transf, sprites)
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
end

return AUXLAYER
