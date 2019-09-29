local functions = {}
local newVec = require "common/vec"
local auxVec = newVec()

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
function functions.up(_, trans, pos)
  auxVec:_init(0, trans.factor)
  print("up", pos - auxVec)
  --pos.delta = - auxVec
  return pos - auxVec
end

-- Inverted logic because of the coordinate system
function functions.down(_, trans, pos)
  auxVec:_init(0, trans.factor)
  print("down", pos + auxVec)
  return pos + auxVec
end

function functions.right(_, trans, pos)
  auxVec:_init(trans.factor, 0)
  print("right", pos + auxVec)
  return pos + auxVec
end

function functions.left(_, trans, pos)
  auxVec:_init(trans.factor, 0)
  print("left", pos - auxVec)
  return pos - auxVec
end

return functions
