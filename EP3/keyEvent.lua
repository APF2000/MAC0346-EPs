local KeyEvent = {}

local KEYBOARD = require "keyboard"
KEYBOARD:hook_love_events()
local DICT = require "dictionary"
local F = require "functions"

local functions = {
  ["zoomIn"] = F.zoomIn,
  ["zoomOut"] = F.zoomOut,
  ["up"] = F.up,
  ["down"] = F.down,
  ["right"] = F.right,
  ["left"] = F.left
}

function KeyEvent:controller(func, parameters)

  --print("params =", parameters, " unpack=", unpack(parameters))
  if KEYBOARD:allDown(DICT[func.name].list) then
    functions[func.name](unpack(parameters))
  end

end

return KeyEvent