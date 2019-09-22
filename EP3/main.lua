-- luacheck: globals love
local Vec = require "common/vec"
local SCENE = require "scene/test"

--local class = require "class" -> Ainda não usado

local v2 = Vec()
local v1 = Vec()

local KEY = require "keyboard"
local DICT = require "dictionary"
local KEYEVENT = require "keyEvent"

--------[[ Defining programm variables ]]--------

-- Window resolution
local W, H

-- Flag for existence of controlled entity (1 if it exists, 0 if doesn't)
local controlled

-- Store all game objects
local objects

--------[[ Auxiliary functions ]]----------------

--- Creates and initializes all game objects according to the given scene, and
--  return them as a list. Also checks if there is a controllable entity and
--  sets the flag 'controlled'.
local function createObjects(scene)
  local all_objects = {}
  local item
  local total
  -- fazer lógica de criação das entidades
  for _, obj in ipairs(scene) do
    total = obj.n
    local count = 0
    while count < total do
      item = generateEntity(obj.entity)
      table.insert(all_objects, item) --appends item to end of all_objects list
      count = count + 1
    end
  end
  return all_objects
end

--- Given the name of the entity, return a list 
local function generateEntity(name)
  -- escrever
end


--------[[ Main game functions ]]----------------

function love.load()
  W, H = love.graphics.getDimensions()
  objects = createObjects(SCENE)
  --controlled = verifyControllableEntity(objects) --Verifica se tem entidade controlada no jogo e armazena na flag
  controlled = 0 --pra testar por enquanto
end

function love.update(dt)
  --[[if KEY:keyDown("lctrl") or KEY:keyDown("rctrl") then
    print("ctrl")

    local som = {"lctrl", "a"}
    if love.keyboard.isDown(som) and love.keyboard.isDown("lalt") then
      print("ctrl alt")
    end

    if KEY:keyDown("I") then
      print("+")
      scaleX = scaleX * scaleFactor
      scaleY = scaleY * scaleFactor
    elseif KEY:keyDown("o") then
      print("-")
      scaleX = scaleX / scaleFactor
      scaleY = scaleY / scaleFactor
    end]]
  for _, func in pairs(DICT) do
    --print("to no for dos comandos", func)
    --[[for i, command in pairs(func) do
      print("comando", i, command)
    end]]
    KEYEVENT:controller(func, scale, trans)
  end
--[[ if KEY:allDown(DICT["zoomIn"]) then
    scale.x = scale.x * scale.factor
    scale.y = scale.y * scale.factor
  elseif KEY:allDown(DICT["zoomOut"]) then
    scale.x = scale.x / scale.factor
    scale.y = scale.y / scale.factor
  elseif KEY:allDown(DICT["left"]) then
    scale.x = scale.x * scale.factor
    scale.y = scale.y * scale.factor
  elseif KEY:allDown(DICT["right"]) then
    scale.x = scale.x * scale.factor
    scale.y = scale.y * scale.factor]]
  --[[else]]if KEY:keyDown("escape") then
    love.event.quit()
  end

  KEY:update(dt)
end


--- Detects when the player presses a keyboard button. Closes the game if it
--  was the ESC button. Moves controlled entity if arrows are pressed.
function love.keypressed (key)
  if key == 'escape' then
    love.event.push 'quit'
  end
end

function love.draw()
  -- Changing world origin to draw things centered on the screen
  love.graphics.push()
  if controlled == 0 then
    love.graphics.translate(W/2, H/2)
  else
    --mudar isso pra posição do objeto controlado!!!
    love.graphics.translate(10, 10)
  end
  -- Put all drawings here:
  love.graphics.circle('line', 0, 0, 1000) -- Map border
  love.graphics.circle('fill', 0, 0, 8)
  --
  love.graphics.pop()

end
