-- luacheck: globals love

local DRAW = {}

function DRAW.player(xp, yp, mov)
  local theta
  local mov_x, mov_y = mov:get()

  love.graphics.setColor(1, 1, 1) --white

  theta = math.atan2(mov_y, mov_x)
  love.graphics.polygon('fill',
        xp-3*math.cos(math.pi/4 + theta),yp-3*math.sin(math.pi/4 + theta),
        xp-3*math.cos(math.pi/4 - theta),yp+3*math.sin(math.pi/4 - theta),
        xp+5*math.cos(theta),            yp+5*math.sin(theta))
end

function DRAW.body(xp, yp, size, hasfield)
  if not hasfield then
    love.graphics.setColor(0, 1, 0) --green
  end

  love.graphics.circle('fill', xp, yp, math.abs(size))

end

function DRAW.field(xp, yp, strength)
  if strength < 0 then
    love.graphics.setColor(1, 0, 0) --red
  elseif strength > 0 then
    love.graphics.setColor(0, 0, 1) --blue
  else
    love.graphics.setColor(0, 1, 0) --green
  end

  love.graphics.circle('line', xp, yp, math.abs(strength))

end

function DRAW.charge(xp, yp, strength)
  if strength < 0 then
    love.graphics.setColor(1, 0, 0) --red
  elseif strength > 0 then
    love.graphics.setColor(0, 0, 1) --blue
  else
    love.graphics.setColor(0, 1, 0) --green
  end

  love.graphics.circle('fill', xp+8, yp, 4)
  love.graphics.circle('fill', xp-8, yp, 4)
end


return DRAW
