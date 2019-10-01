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
--local position = Vec()

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
  scale = {x = 1, y = 1, factor = 1.001}
  trans = {x = 0, y = 0, factor = 10}
  --position:_init(W/2, H/2)
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
        KEYEVENT:controller(func, {scale, trans, plr, dt})
      end
    end
    --Move object:
    plr:move(dt)
    for i, plr in ipairs(player) do
      for j, obj in ipairs(objects) do
        --Handle collisions:
        if j>=i then
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

  if KEY:keyDown("escape") then
    love.event.quit()
  end

  KEY:update(dt)
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
