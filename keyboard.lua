-- luacheck: globals love

local Keyboard = {}

local keyState = {}

function Keyboard:update(dt)
  for k, v in pairs(keyState) do
    keyState[k] = nil
  end
end

-- Retorna o estado atual da tecla
function Keyboard:key(key)
  return love.keyboard.isDown(key)
end

-- Retorna se a tecla foi pressionada no frame atual
function Keyboard:keyDown(key)
  return keyState[key]
end

-- Retorna se a tecla foi solta
function Keyboard:keyUp(key)
  return keyState[key] == false
end

function Keyboard:hook_love_events()
  function love.keypressed(key, scancode, isrepeat)
    keyState[key] = true
  end
  function love.keyreleased(key, scancode)
    keyState[key] = false
  end
end

return Keyboard
