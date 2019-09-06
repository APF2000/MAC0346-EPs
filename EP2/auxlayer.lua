-- luacheck: globals love
local AUXLAYER = {}
local MATRIX = require "matrix"

function AUXLAYER.tilelayer(MAP, height, width, layer, img, blocks)
  local y, z = 1, layer.offsety
  local tilewidth, tileheight = MAP.tilewidth, MAP.tileheight
  for i = 1, height do
    local x = 1
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

function AUXLAYER.sprite(MAP, obj, sprites, layer, z)

  if obj.layer ~= layer.name then return end

  local xobj = (obj.x  / obj.width)
  local yobj = (obj.y / obj.height)

  local transf = MATRIX.linearTransform(xobj,yobj,z,MAP.tilewidth, MAP.tileheight)

  local spr = sprites[obj.name]
  local frameVector = obj.properties.frames
  local total = frameVector.total
  local current = frameVector.current % total + 1
  local frameToSet = frameVector[current]

  local flipX = 1
  if obj.properties.flip == true then
    flipX = -1
  end

  love.graphics.push()
  love.graphics.translate(64, 64*2.8)
  love.graphics.setColor(0, 0, 0 ,0.55)
  love.graphics.ellipse("fill", transf[1][1], transf[2][1], 30, 5)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(spr.img, spr[frameToSet],
    transf[1][1], transf[2][1], 0, flipX, 1,
    obj.properties.offsetx, obj.properties.offsety)
  love.graphics.pop()

  obj.newTime = love.timer.getTime()
  if obj.newTime - obj.oldTime >= 1 / obj.properties.fps then
    frameVector.current = current % total
    obj.oldTime = obj.newTime
  end
end

function AUXLAYER.camera(obj)
  love.graphics.push()
  love.graphics.translate(obj.x, obj.y)
  love.graphics.scale(10, 10)
  love.graphics.pop()
end

return AUXLAYER
