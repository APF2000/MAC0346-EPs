-- Arquivo principal - Implementa módulo para simular as batalhas

local combate = require "combate" --chamando módulo de combate

local SIMULATOR = {}

local function resultadoBatalha(unit_1, unit_2, weapons, scenario)

  local critical = 0
  local acerto = 0
  local double = 0
  local random1 = math.random(1, 100)
  local random2 = math.random(1, 100)
  local random3 = math.random(1, 100)

    --Ataque
    critical = 0
    acerto = combate.acerto(unit_1, unit_2, weapons, random1, random2) --flag de acerto do ataque

    if acerto == 1 then

      critical = combate.critical(unit_1, unit_2, weapons, random3) --flag para indicar se ataque é crítico


      if(unit_1.hp > 0 and unit_2.hp > 0) then
        unit_2.hp = combate.attack(unit_1, unit_2, weapons, critical)
        scenario.units[unit_2.name].hp = unit_2.hp --atualiza vida do defensor


        double = combate.double_attack(unit_1, unit_2, scenario.weapons)


        if(double == 1 and unit_1.hp > 0 and unit_2.hp > 0) then

          unit_2.hp = combate.attack(unit_1, unit_2, weapons, critical)
          scenario.units[unit_2.name].hp = unit_2.hp --atualiza vida do defensor


        end
      end
    end

    --Defesa
    critical = 0

    acerto = combate.acerto(unit_2, unit_1, weapons, random1, random2) --flag de acerto do ataque

    if acerto == 1 then--ataque acertou
      critical = combate.critical(unit_2, unit_1, weapons, random3) --flag para indicar se ataque é crítico

      if unit_1.hp > 0 and unit_2.hp > 0 then
        unit_1.hp = combate.attack(unit_2, unit_1, weapons, critical)
        scenario.units[unit_1.name].hp = unit_1.hp

        double = combate.double_attack(unit_1, unit_2, scenario.weapons)

        if(double == 2 and unit_1.hp > 0 and unit_2.hp > 0) then

          unit_1.hp = combate.attack(unit_2, unit_1, weapons, critical)
          scenario.units[unit_1.name].hp = unit_1.hp --atualiza vida do defensor

        end
      end
    end

  return unit_1, unit_2, scenario

end

function SIMULATOR.run(scenario_input)
  math.randomseed(scenario_input.seed) --inicializa gerador de números pseudoaleatórios com semente adequada

  local weapons = scenario_input.weapons --lista de armas do cenário

  local fights_number = table.getn(scenario_input.fights) --dá número de lutas a serem realizadas neste cenário

  local count = 0 --contador

  while count < fights_number do
    count = count + 1


    local unit_1 = scenario_input.units[scenario_input.fights[count][1]] --obtem unidade atacante
    unit_1.name = scenario_input.fights[count][1]
    -- Novo campo chamado name

    local unit_2 = scenario_input.units[scenario_input.fights[count][2]] --obtem unidade defensora
    unit_2.name = scenario_input.fights[count][2]

    --Decide quem terá double_attack
    --local double = combate.double_attack(unit_1, unit_2, scenario_input.weapons)

    -- Resultado
    if(unit_1.hp > 0 and unit_2.hp > 0) then
      unit_1, unit_2, scenario_input = resultadoBatalha(unit_1, unit_2, weapons, scenario_input)
    end

  end


  local output = scenario_input.units --a saída será apenas os stats das unidades
  return output --Retornar output finalizado
end

return SIMULATOR
