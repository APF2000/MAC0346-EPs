-- luacheck: globals love
local Vec = require "common/vec"
local SCENE = require "scene/test"
local Entity = require "entities_class"

--local class = require "class" -> Ainda não usado

local v2 = Vec()
local v1 = Vec()

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
      count = 0
      while count < total do
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
  player, objects = createObjects(SCENE)
  scale = {x = 1, y = 1, factor = 1.01}
  trans = {x = 0, y = 0, factor = 10}
end


function love.update(dt)

  for _, func in pairs(DICT) do
    --print("for: scale = ", scale, " trans = ", trans)
    KEYEVENT:controller(func, {scale, trans})
  end
  if KEY:keyDown("escape") then
    love.event.quit()
  end

  KEY:update(dt)
end

local ringRadius = 1000

function love.draw()
  local x, y

  -- Changing world origin to draw things centered on the screen
  love.graphics.push()
  if controlled == 0 then --if there is no player, center window on the origin of the world
    love.graphics.translate(W/2, H/2)
  else --if there is a player, center window on the player
    x, y = player[1].position.point:get()
    love.graphics.translate(W/2 - x, H/2 - y)
  end
  love.graphics.pop()

  -- Scaling and translating in player's perspectve
  love.graphics.translate(trans.x, trans.y)
  love.graphics.scale(scale.x, scale.y)

  -- Put all drawings here:
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle('line', 0, 0, ringRadius) -- Map border
  love.graphics.circle('fill', 0, 0, 8) -- Origem do mundo - para visualizar apenas
  -- Nome de variável sujeito a mudança--
  local posx, posy = (W/2 - trans.x)/scale.x, (H/2 - trans.y)/scale.y
  love.graphics.rectangle('fill', posx, posy, 8, 8) -- simboliza posição do jogador

end
