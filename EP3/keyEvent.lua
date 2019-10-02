local KeyEvent = {}

local KEYBOARD = require "keyboard"
KEYBOARD.hook_love_events()
local DICT = require "dictionary"
local F = require "functions"

local functions = {
  ["zoomIn"] = F.zoomIn,
  ["zoomOut"] = F.zoomOut,
  ["up"] = F.up,
  ["down"] = F.down,
  ["right"] = F.right,
  ["left"] = F.left,
  ["stop"] = F.stop
}

function KeyEvent.controller(func, parameters)

if KEYBOARD.allDown(DICT[func.name].list) then
    return functions[func.name](unpack(parameters))
  end
  return parameters[3]

end

return KeyEvent
