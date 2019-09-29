-- luacheck: globals love
local Vec = require "common/vec"
local SCENE = require "scene/test"
local Entity = require "entity/methods/entities_class"
local KEY = require "keyboard"
local DICT = require "dictionary"
local KEYEVENT = require "keyEvent"
local OBJ = require "objects"

--------[[ Defining programm variables ]]--------

-- Window resolution
local W, H

-- Flag for existence of controlled entity (1 if it exists, 0 if doesn't)
local controlled

-- Store game objects and player properties
local objects, player

-- Translations and game scale variables
local scale, trans
local position

-- Size of the game ring:
local ringRadius = 1000


--------[[ Main game functions ]]----------------

function love.load()
  KEY:hook_love_events()
  W, H = love.graphics.getDimensions()

  player, objects, controlled = OBJ.createObjects(SCENE, controlled)
  scale = {x = 1, y = 1, factor = 1.01}
  trans = {x = 0, y = 0, factor = 10}
  position = Vec(W/2, H/2)
end


function love.update(dt)
  --Dealing with user input:
  for _, func in pairs(DICT) do
    position = KEYEVENT:controller(func, {scale, trans, position})
  end
  if KEY:keyDown("escape") then
    love.event.quit()
  end

  KEY:update(dt)
  --

  --Game mechanics:
  --[[pseudo-code:
    --check
  ]]
  --
end


function love.draw()
  local x, y --store player position
  local dx, dy --store scale factor

  -- Changing world origin to draw things centered on the screen
  love.graphics.push()
  if controlled == 0 then --if there is no player, center window on the origin of the world
    love.graphics.scale(scale.x, scale.y)
    love.graphics.translate((W/2)/scale.x, (H/2)/scale.y)
  else --if there is a player, center window on the player
    x, y = player[1].position.point:get()
    dx = x - (W/2)/scale.x
    dy = y - (H/2)/scale.y
    love.graphics.scale(scale.x, scale.y)
    love.graphics.translate(-dx, -dy)
  end

  -- Put all drawings here:
  love.graphics.circle('line', 0, 0, 1000) --Map border
  for _, obj in ipairs(objects) do --drawing objects:
    obj:draw()
  end
  for _, plr in ipairs(player) do --drawing player:
    plr:draw()
  end
  --
  love.graphics.pop()

end
