-- Arquivo principal - Implementa módulo para simular as batalhas

local combate = require "combate" --chamando módulo de combate

local SIMULATOR = {}

function SIMULATOR.run(scenario_input)
  math.randomseed(scenario_input.seed) --inicializa gerador de números pseudoaleatórios com semente adequada


  --[[ Precisa ver como inicializar output de acordo com o do sample scenarios
  local numero_unidades = 0 --contador do numero de unidades do cenário
  for key, value in pairs(scenario_input.units) do
    numero_unidades = numero_unidades + 1
  end

  local contador_output = 1
  while contador_output <= numero_unidades do
    local output.units = ???
  end
  ]]

  local weapons = scenario_input.weapons --lista de armas do cenário


  local fight_number = table.getn(scenario_input.fights) --dá número de lutas a serem realizadas neste cenário
  local count = 1 --contador
  while count <= fight_number do
    local unit_1 = scenario_input.units[scenario_input.fights[count][1]] --obtem unidade atacante
    local unit_2 = scenario_input.units[scenario_input.fights[count][2]] --obtem unidade defensora

    local double_attack = combate.double_attack(unit_1, unit_2, weapons) --flag para indicar se houve segundo ataque e de qual unidade
    local acerto = combate.acerto(unit_1, unit_2, weapons, math.random(), math.random()) --flag de acerto do ataque
    if acerto == 1 then--ataque acertou
      local critical = combate.critical(unit_1, unit_2, weapons, math.random()) --flag para indicar se ataque é crítico
    end
    output.units[unit_2] = combate.attack(unit_1, unit_2, weapons, critical) --atualiza vida do defensor

    if output.units[unit_2] > 0 then --realiza contra-ataque
      acerto = combate.acerto(unit_2, unit_1, weapons, math.random(), math.random()) --flag de acerto do ataque
      if acerto == 1 then--ataque acertou
        critical = combate.critical(unit_2, unit_1, weapons, math.random()) --flag para indicar se ataque é crítico
      end
      output.units[unit_1] = combate.attack(unit_2, unit_1, weapons, critical) --atualiza vida do defensor

      if output.units[unit_1] > 0 and double_attack > 0 then --realiza double attack
        if double_attack == 1 then --unidade 1 ataca novamente
          acerto = combate.acerto(unit_1, unit_2, weapons, math.random(), math.random()) --flag de acerto do ataque
          if acerto == 1 then--ataque acertou
            critical = combate.critical(unit_1, unit_2, weapons, math.random()) --flag para indicar se ataque é crítico
          end
          output.units[unit_2] = combate.attack(unit_1, unit_2, weapons, critical) --atualiza vida do defensor
        else --unidade 1 ataca novamente
          acerto = combate.acerto(unit_2, unit_1, weapons, math.random(), math.random()) --flag de acerto do ataque
          if acerto == 1 then--ataque acertou
            critical = combate.critical(unit_2, unit_1, weapons, math.random()) --flag para indicar se ataque é crítico
          end
          output.units[unit_1] = combate.attack(unit_2, unit_1, weapons, critical) --atualiza vida do defensor
        end
      end
    end
    count = count + 1 --incrementa contador
  end
  return output --Retornar output finalizado
end

return SIMULATOR
