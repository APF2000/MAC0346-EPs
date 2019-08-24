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

  local acerto1 = combate.acerto(unit_1, unit_2, weapons, random1, random2)
  local acerto2 = combate.acerto(unit_2, unit_1, weapons, random1, random2)

  local critical1 = combate.critical(unit_1, unit_2, weapons, random3)
  local critical2 = combate.critical(unit_2, unit_1, weapons, random3)

    --Ataque
    print("VEZ DO ATAQUEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
    if unit_1.hp > 0 and unit_2.hp > 0 then

      if acerto1 == 1 then
          print("acertou")
          unit_2.hp = combate.attack(unit_1, unit_2, weapons, critical1)
          scenario.units[unit_2.name].hp = unit_2.hp --atualiza vida do defensor

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()

      end


      print("vez da defesaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
      --Defesa

      if acerto2 == 1 then
          print("acertou")
          unit_1.hp = combate.attack(unit_2, unit_1, weapons, critical2)
          scenario.units[unit_1.name].hp = unit_1.hp

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()
      end
    end

    double = combate.double_attack(unit_1, unit_2, scenario.weapons)
    print("double = ", double)

    if unit_1.hp > 0 and unit_2.hp > 0  then
      if acerto1 == 1 and double == 1 then
        print("double attackkkkkkkkkkkkkkkkkkkkkkkkkkkk do 1")
        unit_2.hp = combate.attack(unit_1, unit_2, weapons, critical1)
        scenario.units[unit_2.name].hp = unit_2.hp --atualiza vida do defensor

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()
      end

      if acerto2 == 1 and double == 2 then
        print("double attackkkkkkkkkkkkkkkkkkkkkkkkkkkkk do 2")
        unit_1.hp = combate.attack(unit_2, unit_1, weapons, critical2)
        scenario.units[unit_1.name].hp = unit_1.hp --atualiza vida do defensor

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()
      end
    end


  --print("RESBATALHA")
  print(unit_1.name, " tem hp ", unit_1.hp)
  print(unit_2.name, " tem hp ", unit_2.hp)
  print()
  --print()
  return unit_1, unit_2, scenario

end

function SIMULATOR.run(scenario_input)
  math.randomseed(scenario_input.seed) --inicializa gerador de números pseudoaleatórios com semente adequada

  local weapons = scenario_input.weapons --lista de armas do cenário

  local fights_number = table.getn(scenario_input.fights) --dá número de lutas a serem realizadas neste cenário

  local count = 0 --contador

  while count < fights_number do
    count = count + 1

    print("----------------------------------------")

    local unit_1 = scenario_input.units[scenario_input.fights[count][1]] --obtem unidade atacante
    unit_1.name = scenario_input.fights[count][1]
    -- Novo campo chamado name

    local unit_2 = scenario_input.units[scenario_input.fights[count][2]] --obtem unidade defensora
    unit_2.name = scenario_input.fights[count][2]

    print(unit_1.name, " tem hp ", unit_1.hp)
    print(unit_2.name, " tem hp ", unit_2.hp)
    print()

    --Decide quem terá double_attack
    --local double = combate.double_attack(unit_1, unit_2, scenario_input.weapons)

    -- Resultado
    if(unit_1.hp > 0 and unit_2.hp > 0) then
      unit_1, unit_2, scenario_input = resultadoBatalha(unit_1, unit_2, weapons, scenario_input)
    end

  end

  --[[while count <= fights_number and unit_1.hp > 0 and unit_2.hp > 0 do

    local double_attack = combate.double_attack(unit_1, unit_2, weapons) --flag para indicar se houve segundo ataque e de qual unidade

    unit_1, unit_2, scenario_input = resultadoBatalha(unit_1, unit_2, weapons, scenario_input, false)


    if scenario_input.units[unit_2.name].hp > 0  then --realiza contra-ataque

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
  end]]
  local output = scenario_input.units --a saída será apenas os stats das unidades
  return output --Retornar output finalizado
end

return SIMULATOR
