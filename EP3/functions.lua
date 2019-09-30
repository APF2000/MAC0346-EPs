local functions = {}
local newVec = require "common/vec"
local auxVec = newVec()
local delta = newVec()

function functions.zoomIn(scale, trans, pos)
  scale.x = scale.x * scale.factor
  scale.y = scale.y * scale.factor
  return pos
end

function functions.zoomOut(scale, trans, pos)
  scale.x = scale.x / scale.factor
  scale.y = scale.y / scale.factor
  return pos
end

-- Inverted logic because of the coordinate system
function functions.up(_, trans, plr, dt)
  delta:_init(0, plr.control.acceleration * dt * dt / 2)
  plr.position.point = plr.position.point - delta
end

-- Inverted logic because of the coordinate system
function functions.down(_, trans, plr, dt)
  delta:_init(0, plr.control.acceleration * dt * dt / 2)
  plr.position.point = plr.position.point + delta
end

function functions.right(_, trans, plr, dt)
  delta:_init(plr.control.acceleration * dt * dt / 2, 0)
  plr.position.point = plr.position.point + delta
end

function functions.left(_, trans, plr, dt)
  delta:_init(plr.control.acceleration * dt * dt / 2, 0)
  plr.position.point = plr.position.point - delta
end

return functions
