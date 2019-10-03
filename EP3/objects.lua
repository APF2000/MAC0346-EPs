local OBJ = {}

local Entity = require "entities_class"

local player = {}
local controlled
local all_objects = {}

local name
local item
local total
local count

--- Creates and initializes all game objects according to the given scene, and
--  return them as two lists - one with the player properties and the other with
--  all other object properties. Also checks if there is a controllable entity
--  and sets the flag 'controlled' accordingly.
function OBJ.createObjects(scene)

  for _, obj in ipairs(scene) do
    item = Entity()
    name = obj.entity
    if name == 'player' then
      controlled = true
      item:set(name)
      table.insert(player, item)
    else
      total = obj.n
      item:set(name)
      table.insert(all_objects, item)
      count = 1
      while count < total do
        item = Entity()
        item:set(name)
        table.insert(all_objects, item) --appends item to the all_objects list
        count = count + 1
      end
    end
  end
  return player, controlled, all_objects
end


return OBJ
