-- luacheck: globals love
local newVec = require "common/vec"
local v2 = newVec()
local v1 = newVec()
local key = require "keyboard"

function love.load()
  key:hook_love_events()
end

local scaleFactor = 1.1
local scaleX, scaleY = 1, 1

function love.update(dt)
  if key:keyDown("lctrl") or key:keyDown("rctrl") then
    if key:keyDown("kp+") then
      print("+")
      scaleX = scaleX * scaleFactor
      scaleY = scaleY * scaleFactor
    elseif key:keyDown("kp-") then
      print("-")
      scaleX = scaleX / scaleFactor
      scaleY = scaleY / scaleFactor
    end
  elseif key:keyDown("lalt") then
    zoomOut = true
  elseif key:keyDown("escape") then
    love.event.quit()
  end

  key:update(dt)
end

function love.draw()
  love.graphics.scale(scaleX, scaleY)

  love.graphics.setColor(1, 1, 1)
  love.graphics.circle('line', 0, 0, 100)

end
