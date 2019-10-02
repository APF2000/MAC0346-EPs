-- luacheck: globals love

-- Document creating class for entities

local Entity = require 'class' ()

local Vec = require "common/vec"

local OBJECT_SPEED = 100
local MAP_RADIUS = 1000
local x, y


----[[Auxiliary functions]]------

local function generateRandomPosition(rad)
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
  self.hasTPed = false
  self.countTime = 0
end

--[[local function requireEntObj(name)
  local auxName = string.format("entity/%s", name)
  local loaded = love.filesystem.load(auxName)
  return loaded()
end]]

--- According to the name, delete the needless fields and set used fields:
function Entity:set(name)
  local path = "entity/" .. name
  local entity = require(path)

  if entity.position then --field exists
    generateRandomPosition(MAP_RADIUS)
    self.position.point = Vec(x, y)
  else --field does not exist
    self.position = nil
  end
  if entity.movement == nil then --field does not exist
    self.movement = nil
  else --entity has movement
    local rand_x = math.random(-OBJECT_SPEED, OBJECT_SPEED)
    local rand_y = math.random(-OBJECT_SPEED, OBJECT_SPEED)
    self.movement.motion:set(rand_x, rand_y)
  end
  self.body = entity.body
  self.control = entity.control
  self.field = entity.field
  self.charge = entity.charge
end

--- Draws entity according to their properties:
function Entity:draw()
  local hasfield = false --flag to tell if entity has field property
  local hasbody = false --flag to tell if entity has body property

  if self.position then --Entity has position
    local xp,yp = self.position.point:get() --store entitys position

    if self.field then --Entity has field property
      hasfield = true
      -- Defining color of field:
      if self.field.strength < 0 then
        love.graphics.setColor(1, 0, 0) --red
      elseif self.field.strength > 0 then
        love.graphics.setColor(0, 0, 1) --blue
      else
        love.graphics.setColor(0, 1, 0) --green
      end
      -- Drawing field:
      love.graphics.circle('line', xp, yp, math.abs(self.field.strength))
    end

    if self.body then --Entity has body property
      hasbody = true
      -- Defining color of field:
      if not hasfield then --entity does't have field property
        love.graphics.setColor(0, 1, 0) --green
      end
      -- Drawing field:
      love.graphics.circle('fill', xp, yp, math.abs(self.body.size))
    end

    if self.charge then --Entity has charge property
      -- Defining color of charge:
      if self.charge.strength < 0 then
        love.graphics.setColor(1, 0, 0) --red
      elseif self.charge.strength > 0 then
        love.graphics.setColor(0, 0, 1) --blue
      else
        love.graphics.setColor(0, 1, 0) --green
      end
      -- Drawing charge:
      love.graphics.circle('fill', xp+8, yp, 4)
      love.graphics.circle('fill', xp-8, yp, 4)
    end

    if self.control then --Entity has control property (its the player!)
      local theta --store rotation of player
      -- Defining color of player:
      love.graphics.setColor(1, 1, 1) --white
      -- Drawing player:
      local mov_x, mov_y = self.movement.motion:get() --stores player move direction
      theta = math.atan2(mov_y, mov_x)
      love.graphics.polygon('fill',
            xp-3*math.cos(math.pi/4 + theta),yp-3*math.sin(math.pi/4 + theta),
            xp-3*math.cos(math.pi/4 - theta),yp+3*math.sin(math.pi/4 - theta),
            xp+5*math.cos(theta),            yp+5*math.sin(theta))
    end

    if not hasfield and not hasbody then --draw default circle
      -- Defining color of default circle:
      love.graphics.setColor(0, 1, 0) --green
      -- Drawing default circle:
      love.graphics.circle('line', xp, yp, 8)
    end
  end
  -- Puts collor back to default:
  love.graphics.setColor(1, 1, 1) --white
end

--- Mooves entity according to the movement property:
function Entity:move(dt)
  if self.movement then --entity has movement property
    local xp,yp = self.position.point:get() --store entitys position
    local vel = self.movement.motion
    local mov_x, mov_y = vel:get() --stores player move direction
    --local minSpeed = 10
    local waitingTime = 6
    --print("motion=", vel)

    self.position.point:set(xp + mov_x*dt, yp + mov_y*dt)
    xp,yp = self.position.point:get() --store entitys position
    if math.sqrt(xp^2 + yp^2) >= MAP_RADIUS then --is outside map limit
      if not self.hasTPed and self.countTime > waitingTime then
        self.position.point:set(-xp, -yp)
        self.hasTPed = true
      else
        print("else, vel=", -vel)
        self.movement.motion = -vel
        self.hasTPed = false
        self.countTime = (self.countTime + dt) % (waitingTime + 1)
      end
    else
      self.hasTPed = false
      self.countTime = (self.countTime + dt) % (waitingTime + 1)
    end
  end
  print(self.countTime)
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
  --Calculating forces and accelerations:
  F = auxVec*C*f*q/length2
  a = F/m
  --Calculate velocity of moving entity with charge:
  self.movement.motion = self.movement.motion + a*dt
end


--- If entity has mass property (other), prevents that another entity (self)
--  occupies the same space.
function Entity:collision(other)
  local r_s --store self's radius
  if self.body then --has body
    r_s = self.body.size
  else
    r_s = 8 --default size
  end
  local r_o = other.body.size
  local x2 = self.position.point:clone()
  local x1 = other.position.point:clone()
  local delta = x2-x1
  local l = (r_s + r_o) - delta:length()
  local d = delta:normalized()

  if delta:length() < r_s + r_o then --collision
    --Restore to valid position:
    self.position.point = x2 + d*l
    --Correct velocity:
    self.movement.motion = self.movement.motion - d*(self.movement.motion:dot(d))
  end
end

return Entity
