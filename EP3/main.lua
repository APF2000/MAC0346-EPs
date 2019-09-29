-- luacheck: globals love
local Vec = require "common/vec"
local SCENE = require "scene/test"
local Entity = require "entities_class"

local KEY = require "keyboard"
local DICT = require "dictionary"
local KEYEVENT = require "keyEvent"

--------[[ Defining programm variables ]]--------

-- Window resolution
local W, H

-- Flag for existence of controlled entity (1 if it exists, 0 if doesn't)
local controlled

-- Store game objects and player properties
local objects, player

-- Translations and game scale variables
local scale, trans
local position = Vec()

-- Size of the game ring:
local ringRadius = 1000

--------[[ Auxiliary functions ]]----------------

--- Creates and initializes all game objects according to the given scene, and
--  return them as two lists - one with the player properties and the other with
--  all other object properties. Also checks if there is a controllable entity
--  and sets the flag 'controlled' accordingly.
local function createObjects(scene)
  local all_objects = {}
  local player = {}
  local name
  local item
  local total
  local count
  -- fazer lógica de criação das entidades
  for _, obj in ipairs(scene) do
    item = Entity()
    name = obj.entity
    if name == 'player' then
      controlled = 1
      item:set(name)
      table.insert(player, item) --appends item to the player list
    else --any other entity
      total = obj.n
      item:set(name)
      table.insert(all_objects, item) --appends item to the all_objects list
      count = 1
      while count < total do
        item = Entity()
        item:set(name)
        table.insert(all_objects, item) --appends item to the all_objects list
        count = count + 1
      end
    end
  end
  return player, all_objects
end


--------[[ Main game functions ]]----------------

function love.load()
  KEY:hook_love_events()
  W, H = love.graphics.getDimensions()
  print("W=", W, "H=", H)
  print("position", position)

  player, objects = createObjects(SCENE)
  scale = {x = 1, y = 1, factor = 1.01}
  trans = {x = 0, y = 0, factor = 10}
  position:_init(W/2, H/2)
end


function love.update(dt)
  --Dealing with user input:
  for _, func in pairs(DICT) do
    --print("for: scale = ", scale, " trans = ", trans)
    position = KEYEVENT:controller(func, {scale, trans, position})
  end
  if KEY:keyDown("escape") then
    love.event.quit()
  end

  KEY:update(dt)
  --

  --Game mechanics:

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
  for _, obj in ipairs(objects) do --drawing objescts:
    obj:draw()
  end
  for _, plr in ipairs(player) do --drawing player:
    plr:draw()
  end
  --
  love.graphics.pop()

end
