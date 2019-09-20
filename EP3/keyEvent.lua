local KeyEvent = {}

local KEYBOARD = require "keyboard"
KEYBOARD:hook_love_events()
local DICT = require "dictionary"

function zoomIn(scale, trans)
  print("keyEVent zoom in")
  scale.x = scale.x * scale.factor
  scale.y = scale.y * scale.factor
end

function zoomOut(scale, trans)
  print("keyEVent zoom out")
  scale.x = scale.x / scale.factor
  scale.y = scale.y / scale.factor
end

--print("keyevent requerido")

local functions = {
  ["zoomIn"] = zoomIn,
  ["zoomOut"] = zoomOut
}

function KeyEvent:controller(func, scale, trans)
  print("entrei no controller")
  print(KEYBOARD)
  print(DICT)
  print(DICT[func.name].list)
  print(DICT[func.name].list[1])

  if KEYBOARD:allDown(DICT[func.name].list) then
    functions[func.name](scale, trans)
  end
  print("e sai correndo")
end

return KeyEvent
