-- luacheck: globals love

local SCENE = require "scene/test"
local KEY = require "keyboard"
local DICT = require "dictionary"
local KEYEVENT = require "keyEvent"
local OBJ = require "objects"

local W, H
local scale
local ringRadius = 1000

local player, controlled, objects

function love.load()
  KEY.hook_love_events()
  W, H = love.graphics.getDimensions()

  player, controlled, objects = OBJ.createObjects(SCENE)
  scale = {x = 1, y = 1, factor = 1.001}
end


function love.update(dt)
  -- Game mechanics:
  --Dealing with all objects except the player
  for i, obj1 in ipairs(objects) do
    for j, obj2 in ipairs(objects) do
      --Change velocity vector due to force interaction:
      if j >= i then
        if obj1.charge and obj1.movement then --has charge and movement properties
          if obj2.field then --has field property
            obj1:force(obj2, dt)
          end
        end
      end
    end
    --Move object:
    obj1:move(dt)
  end
  for i, obj1 in ipairs(objects) do
    for j, obj2 in ipairs(objects) do
      --Handle collisions:
      if j>=i then
        if obj2.body and obj1.movement then
          obj1:collision(obj2)
        end
      end
    end
  end
  --Dealing with the player
  for i, plr in ipairs(player) do
    for j, obj in ipairs(objects) do
      --Change velocity vector due to force interaction:
      if j >= i then
        --putting force on player
        if plr.charge and plr.movement then --has charge and movement properties
          if obj.field then --has field property
            plr:force(obj, dt)
          end
        end
        --putting force from player, on all other units
        if obj.charge and obj.movement then --has charge and movement properties
          if plr.field then --has field property
            obj:force(plr, dt)
          end
        end
      end
      --Dealing with user input:
      for _, func in pairs(DICT) do
        --print("for: scale = ", scale, " trans = ", trans)
        KEYEVENT.controller(func, {scale, plr, dt})
      end
    end
    --Move object:
    plr:move(dt)
    for i2, _ in ipairs(player) do
      for j, obj in ipairs(objects) do
        --Handle collisions:
        if j>=i2 then
          --player collides with object
          if obj.body and plr.movement then --has body property
            plr:collision(obj)
          end
          --object collides with player
          if plr.body and obj.movement then --has body property
            obj:collision(plr)
          end
        end
      end
    end
  end

  if KEY.keyDown("escape") then
    love.event.quit()
  end

  KEY.update(dt)
  --
end


function love.draw()
  local x, y --store player position
  local dx, dy --store scale factor

  -- Changing world origin to draw things centered on the screen
  love.graphics.push()
  if not controlled then -- center window on the origin of the world
    love.graphics.scale(scale.x, scale.y)
    love.graphics.translate((W/2)/scale.x, (H/2)/scale.y)
  else -- center window on the player
    x, y = player[1].position.point:get()
    dx = x - (W/2)/scale.x
    dy = y - (H/2)/scale.y
    love.graphics.scale(scale.x, scale.y)
    love.graphics.translate(-dx, -dy)
  end

  love.graphics.circle('line', 0, 0, ringRadius)
  for _, obj in ipairs(objects) do
    obj:draw()
  end
  for _, plr in ipairs(player) do
    plr:draw()
  end
  --
  love.graphics.pop()

end
