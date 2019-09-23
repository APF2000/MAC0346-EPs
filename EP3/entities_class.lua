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

local function generateRandomPosition()
  local x = math.random(-999, 999)
  local y = math.random(-999, 999)
  while math.sqrt(x^2 + y^2) >= 1000 do
    x = math.random(-999, 999)
    y = math.random(-999, 999)
  end
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

function Entity:set(name)
  --According to the name, delete the needless fields and set used fields
  if name == 'player' then
    local x, y = generateRandomPosition()
    self.position.point = Vec(x, y)
    self.movement.motion = Vec(math.random(OBJECT_SPEED/3, OBJECT_SPEED), math.random(OBJECT_SPEED/3, OBJECT_SPEED))
    self.body = nil
    self.control.acceleration = player.control.acceleration
    self.control.max_speed = player.control.max_speed
    self.field.strength = player.field.strength
    self.charge = nil

  elseif name == 'large' then
    local x, y = generateRandomPosition()
    self.position.point = Vec(x, y)
    self.movement = nil
    self.body.size = large.body.size
    self.control = nil
    self.field = nil
    self.charge = nil

  elseif name == 'simpleneg' then
    local x, y = generateRandomPosition()
    self.position.point = Vec(x, y)
    self.movement.motion = Vec(math.random(OBJECT_SPEED/3, OBJECT_SPEED), math.random(OBJECT_SPEED/3, OBJECT_SPEED))
    self.body = nil
    self.control = nil
    self.field = nil
    self.charge.strength = simpleneg.charge.strength

  elseif name == 'simplepos' then
    local x, y = generateRandomPosition()
    self.position.point = Vec(x, y)
    self.movement.motion = Vec(math.random(OBJECT_SPEED/3, OBJECT_SPEED), math.random(OBJECT_SPEED/3, OBJECT_SPEED))
    self.body = nil
    self.control = nil
    self.field = nil
    self.charge.strength = simplepos.charge.strength

  elseif name == 'slowpos' then
    local x, y = generateRandomPosition()
    self.position.point = Vec(x, y)
    self.movement.motion = Vec(math.random(OBJECT_SPEED/10, OBJECT_SPEED/3), math.random(OBJECT_SPEED/10, OBJECT_SPEED/3))
    self.body.size = slowpos.body.size
    self.control = nil
    self.field = slowpos.field
    self.charge.strength = slowpos.charge.strength

  elseif name == 'strongneg' then
    local x, y = generateRandomPosition()
    self.position.point = Vec(x, y)
    self.movement = nil
    self.body.size = strongneg.body.size
    self.control = nil
    self.field.strength = strongneg.field.strength
    self.charge = nil

  elseif name == 'strongpos' then
    local x, y = generateRandomPosition()
    self.position.point = Vec(x, y)
    self.movement.motion = Vec(math.random(OBJECT_SPEED/5, OBJECT_SPEED/2), math.random(OBJECT_SPEED/5, OBJECT_SPEED/2))
    self.body.size = strongpos.body.size
    self.control = nil
    self.field.strength = strongpos.field.strength
    self.charge.strength = strongpos.charge.strength

  end
end

return Entity
