-- luacheck: globals love

local Entity = require 'class' ()

local Vec = require "common/vec"
local Draw = require "draw"

local OBJECT_SPEED = 100
local MAP_RADIUS = 1000
local x, y

local function generateRandomPosition(rad)
  repeat
    x = math.random(-rad, rad)
    y = math.random(-rad, rad)
  until math.sqrt(x^2 + y^2) < rad
  return x, y
end

function Entity:_init()
  self.position = {point = Vec(0, 0)}
  self.movement = {motion = Vec(0, 0)}
  self.body = {size = 8}
  self.control = {acceleration = 0.0, max_speed = 50.0}
  self.field = {strength = 1}
  self.charge = {strength = 1}
  self.hasTPed = false
  self.countTime = 0
end

function Entity:set(name)
  local path = "entity/" .. name
  local entity = require(path)

  if entity.position then
    generateRandomPosition(MAP_RADIUS)
    self.position.point = Vec(x, y)
  else
    self.position = nil
  end
  if entity.movement == nil then
    self.movement = nil
  else
    local rand_x = math.random(-OBJECT_SPEED, OBJECT_SPEED)
    local rand_y = math.random(-OBJECT_SPEED, OBJECT_SPEED)
    self.movement.motion:set(rand_x, rand_y)
  end
  self.body = entity.body
  self.control = entity.control
  self.field = entity.field
  self.charge = entity.charge
end

--- Draws entity according to their properties
function Entity:draw()
  local hasfield = false
  local hasbody = false

  if self.position then
    local xp,yp = self.position.point:get()

    if self.control then
      local mov = self.movement.motion
        Draw.player(xp, yp, mov)
    end

    if self.body then
      hasbody = true
      local size = self.body.size
      Draw.body(xp, yp, size, hasfield)
    end

    if self.field then
      hasfield = true
      local strength = self.field.strength
      Draw.field(xp, yp, strength)
    end

    if self.charge then
      local strength = self.charge.strength
      Draw.charge(xp, yp, strength)
    end

    if not hasfield and not hasbody then -- default

      love.graphics.setColor(0, 1, 0) --green

      love.graphics.circle('line', xp, yp, 8)
    end
  end
  -- Puts collor back to default:
  love.graphics.setColor(1, 1, 1) --white
end

-- Moves entity according to the movement property:
function Entity:move(dt)
  if self.movement then
    local xp,yp = self.position.point:get()
    local vel = self.movement.motion
    local mov_x, mov_y = vel:get()

    self.position.point:set(xp + mov_x*dt, yp + mov_y*dt)
    xp,yp = self.position.point:get()

    if math.sqrt(xp^2 + yp^2) > MAP_RADIUS then
      local dir = - self.position.point:normalized()
      self.position.point = dir * MAP_RADIUS
    end
  end
end


--- Changes the velocity vector of a moving entity with charge (self) based on
--  the force interection with an entity with field (other).
function Entity:force(other, dt)
  local F --force vector
  local C = 1000 --attraction canstant
  local f = other.field.strength
  local vec_xf = other.position.point:clone()
  local q = self.charge.strength
  local vec_xq = self.position.point:clone()
  local a --acceleration vector
  local m --mass of charged unit
  local auxVec = (vec_xq - vec_xf)
  local length2 = auxVec:dot(auxVec)
  if self.body == nil then
    m = 1
  else
    m = self.body.size
  end

  F = auxVec*C*f*q/length2
  a = F/m

  self.movement.motion = self.movement.motion + a*dt
end

function Entity:collision(other)
  local selfRadius
  if self.body then
    selfRadius = self.body.size
  else
    selfRadius = 8 --default
  end
  local r_o = other.body.size
  local x2 = self.position.point:clone()
  local x1 = other.position.point:clone()
  local delta = x2-x1
  local l = (selfRadius + r_o) - delta:length()
  local d = delta:normalized()

  if delta:length() < selfRadius + r_o then --collision
    --Restore to valid position:
    self.position.point = x2 + d*l
    --Correct velocity:
    self.movement.motion = self.movement.motion - d*(self.movement.motion:dot(d))
  end
end

return Entity
