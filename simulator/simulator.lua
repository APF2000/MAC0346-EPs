-- Arquivo principal - Implementa módulo para simular as batalhas

local combate = require "combate" --chamando módulo de combate

local SIMULATOR = {}

local function resultadoBatalha(unit_1, unit_2, weapons, scenario)

    -- Ataque
    print("VEZ DO ATAQUEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
    if unit_1.hp > 0 and unit_2.hp > 0 then
      --Verificando se acertou:
      local acerto = combate.acerto(unit_1, unit_2, weapons, math.random(1,100), math.random(1,100))
      if acerto == 1 then
          print("acertou")
          --Calculando se é crítico:
          local critical = combate.critical(unit_1, unit_2, weapons, math.random(1, 100))
          --Executando ataque:
          unit_2.hp = combate.attack(unit_1, unit_2, weapons, critical)
          scenario.units[unit_2.name].hp = unit_2.hp --atualiza vida do defensor

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()

      end
    end

    -- Defesa
    print("vez da defesaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    if unit_2.hp > 0 then --verifica se unidade defensora ainda está viva
      --Verificando se acertou:
      local acerto = combate.acerto(unit_2, unit_1, weapons, math.random(1,100), math.random(1,100))
      if acerto == 1 then
          print("acertou")
          --Calculando se é crítico:
          local critical = combate.critical(unit_2, unit_1, weapons, math.random(1,100))
          --Executando ataque:
          unit_1.hp = combate.attack(unit_2, unit_1, weapons, critical)
          scenario.units[unit_1.name].hp = unit_1.hp

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()
      end
    end

    -- Double Attack
    local double_attack = combate.double_attack(unit_1, unit_2, scenario.weapons)
    print("double = ", double_attack)

    if unit_1.hp > 0 and unit_2.hp > 0  and double_attack then --verifica se ambas unidades estão vivas e houve double attack
      if double_attack == 1 then --double attack da unidade atacante
        print("double attackkkkkkkkkkkkkkkkkkkkkkkkkkkk do 1")
        --Verificando se acertou:
        local acerto = combate.acerto(unit_1, unit_2, weapons, math.random(1,100), math.random(1,100))
        if acerto == 1 then
          print("acertou")
          --Calculando se é crítico:
          local critical = combate.critical(unit_1, unit_2, weapons, math.random(1,100))
          --Executando ataque:
          unit_2.hp = combate.attack(unit_1, unit_2, weapons, critical)
          scenario.units[unit_2.name].hp = unit_2.hp --atualiza vida do defensor

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()
        end

      else --double attack da unidade defensora
        print("double attackkkkkkkkkkkkkkkkkkkkkkkkkkkkk do 2")
        --Verificando se acertou:
        local acerto = combate.acerto(unit_2, unit_1, weapons, math.random(1,100), math.random(1,100))
        if acerto == 1 then
          print("acertou")
          --Calculando se é crítico:
          local critical = combate.critical(unit_2, unit_1, weapons, math.random(1,100))
          --Executando ataque:
          unit_1.hp = combate.attack(unit_2, unit_1, weapons, critical)
          scenario.units[unit_1.name].hp = unit_1.hp --atualiza vida do defensor

          print(unit_1.name, " tem hp ", unit_1.hp)
          print(unit_2.name, " tem hp ", unit_2.hp)
          print()
        end --if de acerto
      end --elseif de quem ataca
    end --if do double attack


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
