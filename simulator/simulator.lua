-- Arquivo principal - Implementa módulo para simular as batalhas

local combate = require "combate" --chamando módulo de combate

local SIMULATOR = {}

local function resultadoBatalha(unit_1, unit_2, weapons, scenario_input, ataque)

  acerto = combate.acerto(unit_1, unit_2, weapons, math.random(1, 100), math.random(1, 100)) --flag de acerto do ataque

  if acerto == 1 then--ataque acertou
    critical = combate.critical(unit_1, unit_2, weapons, math.random(1, 100)) --flag para indicar se ataque é crítico
  end

  if(ataque == true) then --se o atacante for a unidade 1
    --print(combate.attack(unit_2, unit_1, weapons, critical))
    --print(scenario_input.units[unit_1].hp)
    scenario_input.units[unit_1.name].hp = combate.attack(unit_1, unit_2, weapons, critical) --atualiza vida do defensor
    unit_1.hp = combate.attack(unit_1, unit_2, weapons, critical)

  else
    print()

    --[[print(combate.attack(unit_2, unit_1, weapons, critical))
    print(scenario_input.units)
    print(scenario_input.units["Brigand"])
    print(scenario_input.units[unit_2])
    print(scenario_input.units[unit_2])
    print(scenario_input.units.unit_2)
    print(unit_1.name)
    print(unit_2.name)]]


    print()
    scenario_input.units[unit_2.name].hp = combate.attack(unit_1, unit_2, weapons, critical)
    unit_2.hp = combate.attack(unit_1, unit_2, weapons, critical)
end
  print("RESBATALHA")
  print(unit_1.name, " tem hp ", unit_1.hp)
  print(unit_2.name, " tem hp ", unit_2.hp)
  print()
  return unit_1, unit_2, scenario_input
end

function SIMULATOR.run(scenario_input)
  math.randomseed(scenario_input.seed) --inicializa gerador de números pseudoaleatórios com semente adequada

  local weapons = scenario_input.weapons --lista de armas do cenário

  local fight_number = table.getn(scenario_input.fights) --dá número de lutas a serem realizadas neste cenário

  local count = 1 --contador

  while count <= fight_number do
    local unit_1 = scenario_input.units[scenario_input.fights[count][1]] --obtem unidade atacante
    unit_1.name = scenario_input.fights[count][1]
    -- Novo campo chamado name
    --print(scenario_input.units[scenario_input.fights[count]])
    local unit_2 = scenario_input.units[scenario_input.fights[count][2]] --obtem unidade defensora
    unit_2.name = scenario_input.fights[count][2]

    local double_attack = combate.double_attack(unit_1, unit_2, weapons) --flag para indicar se houve segundo ataque e de qual unidade

    unit_1, unit_2, scenario_input = resultadoBatalha(unit_1, unit_2, weapons, scenario_input, false)


    if scenario_input.units[unit_2.name].hp > 0 then --realiza contra-ataque

      unit_1, unit_2, scenario_input = resultadoBatalha(unit_1, unit_2, weapons, scenario_input, true)


      if scenario_input.units[unit_1.name].hp > 0 and double_attack > 0 then --realiza double attack
        if double_attack == 1 then --unidade 1 ataca novamente

          unit_1, unit_2, scenario_input = resultadoBatalha(unit_1, unit_2, weapons, scenario_input, false)

        else --unidade 1 ataca novamente
          unit_1, unit_2, scenario_input = resultadoBatalha(unit_1, unit_2, weapons, scenario_input, true)
        end
      end
    end
    count = count + 1 --incrementa contador
  end
  local output = scenario_input.units --a saída será apenas os stats das unidades
  return output --Retornar output finalizado
end

return SIMULATOR
