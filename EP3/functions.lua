local functions = {}
local newVec = require "common/vec"
local delta = newVec()

function functions.zoomIn(scale)
  scale.x = scale.x * scale.factor
  scale.y = scale.y * scale.factor
end

function functions.zoomOut(scale)
  scale.x = scale.x / scale.factor
  scale.y = scale.y / scale.factor
end

function functions.up(_, plr, dt)
  delta:_init(0, plr.control.acceleration*dt)
  plr.movement.motion = plr.movement.motion - delta
  plr.movement.motion:clamp(plr.control.max_speed)
end

function functions.down(_, plr, dt)
  delta:_init(0, plr.control.acceleration*dt)
  plr.movement.motion = plr.movement.motion + delta
  plr.movement.motion:clamp(plr.control.max_speed)
end

function functions.right(_, plr, dt)
  delta:_init(plr.control.acceleration*dt, 0)
  plr.movement.motion = plr.movement.motion + delta
  plr.movement.motion:clamp(plr.control.max_speed)
end

function functions.left(_, plr, dt)
  delta:_init(plr.control.acceleration*dt, 0)
  plr.movement.motion = plr.movement.motion - delta
  plr.movement.motion:clamp(plr.control.max_speed)
end

function functions.stop(_, plr)
  plr.movement.motion = newVec(0, 0)
end

return functions
