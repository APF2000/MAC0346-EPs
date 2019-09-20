
local KEYBOARD = require "keyboard"
local DICT = require "dictionary"

function zoomIn(scale, trans)
  print("keyEVent zoom in")
  scale.x = scale.x * scale.factor
  scale.y = scale.y * scale.factor
end


local KeyEvent = {
  ["zoomIn"] = zoomIn()
}

function KeyEvent:controller()

end

return KeyEvent
