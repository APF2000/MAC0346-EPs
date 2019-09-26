-- luacheck: globals love

-- Document creating class for entities

local Entity = require 'class' ()

local Vec = require "common/vec"
local large = require "entity/large"
local player = require "entity/player"
local simpleneg = require "entity/simpleneg"
local simplepos = require "entity/simplepos"
local slowpos = require "entity/slowpos"
local strongneg = require "entity/strongneg"
local strongpos = require "entity/strongpos"

local OBJECT_SPEED = 164


----[[Auxiliary functions]]------

local function generateRandomPosition(rad)
  --[[local x = math.random(-999, 999)
  local y = math.random(-999, 999)
  while math.sqrt(x^2 + y^2) >= 1000 do
    x = math.random(-999, 999)
    y = math.random(-999, 999)
  end]]
  repeat
    x = math.random(-rad, rad)
    y = math.random(-rad, rad)
  until math.sqrt(x^2 + y^2) < rad
  return x, y
end

----[[Class functions]]------

function Entity:_init()
  --Initializing with default values
  self.position = {point = Vec(0, 0)}
  self.movement = {motion = Vec(0, 0)}
  self.body = {size = 8}
  self.control = {acceleration = 0.0, max_speed = 50.0}
  self.field = {strength = 1}
  self.charge = {strength = 1}
end

local function requireEntObj(name)
  local auxName = string.format("entity/%s", name)
  local loaded = love.filesystem.load(auxName)
  return loaded()
end

--- According to the name, delete the needless fields and set used fields
function Entity:set(name)
  local path = "entity/" .. name
  local entity = require(path)

  if entity.position then --field exists
    local x, y = generateRandomPosition(1000)
    self.position.point = Vec(x, y)
  else --field does not exist
    self.position = nil
  end
  if entity.movement == nil then --field does not exist
    self.movement = nil
  end
  self.body = entity.body
  self.control = entity.control
  self.field = entity.field
  self.charge = entity.charge
end

return Entity
