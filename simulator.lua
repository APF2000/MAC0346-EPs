--[[
entrada:

1 -  O estado das unidades
2 -  A sequencia de ataques realizados entre unidades

E deverão devolver como resultado:

O estado final das unidades após os ataques

]]

local req = require "atributos"

local SIMULATOR = {}

function SIMULATOR.run(scenario_input)

  --Importante colocar antes de tudo um: math.randomseed(scenario_input.seed)
  -- para depois manter a consistencias nos math.random()

  --Processar sequencia de ataques
    -- Executar um ataque
    -- Armazenar resultados na variável de output
  --Retornar output finalizado
  print("passei por aqui!")
  return scenario_input
end

return SIMULATOR
