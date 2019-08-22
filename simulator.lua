-- Arquivo principal - Implementa módulo para simular as batalhas

local combate = require "combate" --chamando módulo de combate

local SIMULATOR = {}

local function calculaCritical(unit_1, unit_2, weapons, ataque)
  acerto = combate.acerto(unit_2, unit_1, weapons, math.random(1, 100), math.random(1, 100)) --flag de acerto do ataque
  if acerto == 1 then--ataque acertou
    critical = combate.critical(unit_2, unit_1, weapons, math.random(1, 100)) --flag para indicar se ataque é crítico
  end
  if(ataque == true) then --se o atacante for a unidade 1
    scenario_input.units[unit_1].hp = combate.attack(unit_2, unit_1, weapons, critical) --atualiza vida do defensor
  end
  else
    scenario_input.units[unit_2].hp = combate.attack(unit_1, unit_2, weapons, critical)
  end
end

function SIMULATOR.run(scenario_input)
  math.randomseed(scenario_input.seed) --inicializa gerador de números pseudoaleatórios com semente adequada

  local weapons = scenario_input.weapons --lista de armas do cenário

  local fight_number = table.getn(scenario_input0.fights) --dá número de lutas a serem realizadas neste cenário
  local count = 1 --contador



  while count <= fight_number do
    local unit_1 = scenario_input.units[scenario_input.fights[count][1]] --obtem unidade atacante
    local unit_2 = scenario_input.units[scenario_input.fights[count][2]] --obtem unidade defensora

    local double_attack = combate.double_attack(unit_1, unit_2, weapons) --flag para indicar se houve segundo ataque e de qual unidade

    calculaCritical(unit_1, unit_2, weapons, false)


    if scenario_input.units[unit_2].hp > 0 then --realiza contra-ataque

      calculaCritical(unit_1, unit_2, weapons, true)


      if scenario_input.units[unit_1].hp > 0 and double_attack > 0 then --realiza double attack
        if double_attack == 1 then --unidade 1 ataca novamente

          calculaCritical(unit_1, unit_2, weapons, false)

        else --unidade 1 ataca novamente
          calculaCritical(unit_1, unit_2, weapons, true)
        end
      end
    end
    count = count + 1 --incrementa contador
  end
  local output = scenario_input.units --a saída será apenas os stats das unidades
  return output --Retornar output finalizado
end

return SIMULATOR
