-- luacheck: globals love
local newVec = require "common/vec"
local v2 = newVec()
local v1 = newVec()

v1:_init(1, 1)
v2:_init(1, 2)

print(v1:__tostring())
print(v2:__tostring())

print(v2:dot(v1))

local v3 = v1 + v2
print(v3)

function love.load()

end

function love.update(dt)
  if(love.keyboard.isDown('a')) then
    print("uaudeucerto")
  end
end

local text = ""

function love.keypressed(key, unicode)
  if key == "escape" then
    love.event.quit()
  end

end

function love.textinput(t)
    text = text .. t
end

function love.draw()
  love.graphics.printf(text, 0, 0, 800)
end
