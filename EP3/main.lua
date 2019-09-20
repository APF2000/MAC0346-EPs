-- luacheck: globals love
local newVec = require "common/vec"
local v2 = newVec()
local v1 = newVec()
local KEY = require "keyboard"
local DICT = require "dictionary"
local KEYEVENT = require "keyEvent"

function love.load()
  KEY:hook_love_events()
end

--[[local scaleFactor = 1.02
local scaleX, scaleY = 1, 1]]

local scale = {x = 1, y = 1, factor = 1.02}

--[[local transFactor = 10
local transX, transY = 0, 0]]

local trans = {x = 0, y = 0, factor = 10}

function love.update(dt)
  --[[if KEY:keyDown("lctrl") or KEY:keyDown("rctrl") then
    print("ctrl")

    local som = {"lctrl", "a"}
    if love.keyboard.isDown(som) and love.keyboard.isDown("lalt") then
      print("ctrl alt")
    end

    if KEY:keyDown("I") then
      print("+")
      scaleX = scaleX * scaleFactor
      scaleY = scaleY * scaleFactor
    elseif KEY:keyDown("o") then
      print("-")
      scaleX = scaleX / scaleFactor
      scaleY = scaleY / scaleFactor
    end]]
  for _, func in pairs(DICT) do
    print("to no for dos comandos", func)
    --[[for i, command in pairs(func) do
      print("comando", i, command)
    end]]
    KEYEVENT:controller(func, scale, trans)
  end
--[[ if KEY:allDown(DICT["zoomIn"]) then
    scale.x = scale.x * scale.factor
    scale.y = scale.y * scale.factor
  elseif KEY:allDown(DICT["zoomOut"]) then
    scale.x = scale.x / scale.factor
    scale.y = scale.y / scale.factor
  elseif KEY:allDown(DICT["left"]) then
    scale.x = scale.x * scale.factor
    scale.y = scale.y * scale.factor
  elseif KEY:allDown(DICT["right"]) then
    scale.x = scale.x * scale.factor
    scale.y = scale.y * scale.factor]]
  --[[else]]if KEY:keyDown("escape") then
    love.event.quit()
  end

  KEY:update(dt)
end



--[[function love.keypressed(key, unicode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
  if key == 'lctrl' or key == 'rctrl' or key == '+' then
    print("ctrlkeypressed")
    if(love.keyboard.isDown('lctrl')) then
      print("left")
    end
    if(love.keyboard.isDown('[')) then
      print("+")
      love.graphics.scale(2.0, 2.0)
    end
  end
end]]

function love.draw()
  love.graphics.scale(scale.x, scale.y)
  love.graphics.translate(trans.x, trans.y)

  love.graphics.setColor(1, 1, 1)
  love.graphics.circle('line', 0, 0, 100)

end
