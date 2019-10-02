-- luacheck: globals love

local Keyboard = {}

local keyState = {}

function Keyboard.update(_)
  for k, _ in pairs(keyState) do
    keyState[k] = nil
  end
end

function Keyboard.allDown(keys)
  if keys == nil then return end

  for _, key in pairs(keys) do
    if type(key) ~= "table" and not love.keyboard.isDown(key) then
      return false
    end
  end
  return true
end

-- Retorna se a tecla foi pressionada no frame atual
function Keyboard.keyDown(key)
  return keyState[key]
end

-- Retorna se a tecla foi solta
function Keyboard.keyUp(key)
  return keyState[key] == false
end

function Keyboard.hook_love_events()
  function love.keypressed(key)
    keyState[key] = true
  end
  function love.keyreleased(key)
    keyState[key] = false
  end
end

return Keyboard
