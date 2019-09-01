local MATRIX = {}

function MATRIX.linearTransform(x, y, z, w, h)
  return {
    {(x - y) * w / 2},
    {(x + y) * h / 2 + z}
  }
end

return MATRIX
