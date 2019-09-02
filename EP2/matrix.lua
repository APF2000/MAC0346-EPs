local MATRIX = {}

function MATRIX.linearTransform(x, y, z, w, h)
  local xx = (x - y) * w / 2
  local yy = z + ((x + y) * h / 2)
  --print("x=", x, ",y=", y, ", z=", z)
  --print("xx=", xx, ",yy= ", yy)
  return {
    {xx},
    {yy}
  }
end

return MATRIX
