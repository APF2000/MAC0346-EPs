--[[
entrada:

1 -  O estado das unidades
2 -  A sequencia de ataques realizados entre unidades

E deverão devolver como resultado:

O estado final das unidades após os ataques

]]


--result = SIMULATOR.run(scenario_input)

local req = require "atributos"

local SIMULATOR = {}

function SIMULATOR.run(scenario_input)

  --Colocar lógica aqui
  print("passei por aqui!")
  return scenario_input
  --return scenario_input.units
end

return SIMULATOR
