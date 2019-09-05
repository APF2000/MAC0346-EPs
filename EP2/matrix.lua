local MATRIX = {}

function MATRIX.linearTransform(x, y, z, w, h)
  local xx = math.floor((x - y) * w / 2)
  local yy = math.floor(z + ((x + y) * h / 2))
  return {
    {xx},
    {yy}
  }
end

return MATRIX
