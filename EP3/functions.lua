local functions = {}

function functions.zoomIn(scale, trans)
  scale.x = scale.x * scale.factor
  scale.y = scale.y * scale.factor
end

function functions.zoomOut(scale, trans)
  scale.x = scale.x / scale.factor
  scale.y = scale.y / scale.factor
end

function functions.up(_, trans)
  trans.y = trans.y + trans.factor
end

function functions.down(_, trans)
  trans.y = trans.y - trans.factor
end

function functions.right(_, trans)
  trans.x = trans.x - trans.factor
end

function functions.left(_, trans)
  trans.x = trans.x + trans.factor
end

return functions
