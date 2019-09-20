local KeyEvent = {}

local KEYBOARD = require "keyboard"
KEYBOARD:hook_love_events()
local DICT = require "dictionary"
local F = require "functions"

--print("keyevent requerido")

local functions = {
  ["zoomIn"] = F.zoomIn,
  ["zoomOut"] = F.zoomOut,
  ["up"] = F.up,
  ["down"] = F.down,
  ["right"] = F.right,
  ["left"] = F.left
}

function KeyEvent:controller(func, scale, trans)
  print("entrei no controller")
--[[  print(KEYBOARD)
  print(DICT)
  print(DICT[func.name].list)
  print(DICT[func.name].list[1])]]

  if KEYBOARD:allDown(DICT[func.name].list) then
    functions[func.name](scale, trans)
  end
  print("e sai correndo")
end

return KeyEvent
