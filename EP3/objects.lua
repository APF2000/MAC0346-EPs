local Entity = require "entity/methods/entities_class"

local Objects = {}

local all_objects = {}
local player = {}
local name
local item
local total
local count
--- Creates and initializes all game objects according to the given scene, and
--  return them as two lists - one with the player properties and the other with
--  all other object properties. Also checks if there is a controllable entity
--  and sets the flag 'controlled' accordingly.
function Objects.createObjects(scene, controlled)
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
  return player, all_objects, controlled
end

return Objects
