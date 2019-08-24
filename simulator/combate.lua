-- Neste arquivo é implementado o módulo de combate do jogo

local COMBATE = {}

-- Definimos a tabela do triangle bonus, para poder consultar a cada combate
-- com facilidade:
local triangle_bonus_table = {
  ["sword"] = {
    ["sword"]=0, ["axe"]=1, ["lance"]=-1, ["bow"]=0, ["wind"]=0, ["thunder"]=0, ["fire"]=0
  },
  ["axe"] = {
    ["sword"]=-1,["axe"]=0, ["lance"]=1, ["bow"]=0, ["wind"]=0, ["thunder"]=0, ["fire"]=0
  },
  ["lance"] = {
    ["sword"]=1, ["axe"]=-1, ["lance"]=0, ["bow"]=0, ["wind"]=0, ["thunder"]=0, ["fire"]=0
  },
  ["bow"] = {
    ["sword"]=0, ["axe"]=0, ["lance"]=0, ["bow"]=0, ["wind"]=0, ["thunder"]=0, ["fire"]=0
  },
  ["wind"] = {
    ["sword"]=0, ["axe"]=0, ["lance"]=0, ["bow"]=0, ["wind"]=0, ["thunder"]=1, ["fire"]=-1
  },
  ["thunder"] = {
    ["sword"]=0, ["axe"]=0, ["lance"]=0, ["bow"]=0, ["wind"]=-1, ["thunder"]=0, ["fire"]=1
  },
  ["fire"] = {
    ["sword"]=0, ["axe"]=0, ["lance"]=0, ["bow"]=0, ["wind"]=1, ["thunder"]=-1, ["fire"]=0
  }
}


function COMBATE.double_attack(unit_1, unit_2, weapons)
  --[[ Função que recebe como entrada duas listas de stats de duas unidades em
  combate; e uma lista das armas do jogo e seus atributos.
  Retorna 1 se houver double attack da unidade 1, 2 se houver double
  attack da unidade 2, ou 0 se não houver double attack por nenhuma das partes.
  ]]
  local weapon_1 = unit_1.weapon --pega a arma da unidade 1
  local weapon_2 = unit_2.weapon --pega a arma da unidade 2
  local atk_speed_1 = unit_1.spd - math.max(0, weapons[weapon_1].wt - unit_1.str)
  local atk_speed_2 = unit_2.spd - math.max(0, weapons[weapon_2].wt - unit_2.str)
  --print("atk_speed_1", atk_speed_1)
  --print("atk_speed_2", atk_speed_2)

  --[[print("DOUBLE ATTACK")
  print(unit_1.name, " tem hp ", unit_1.hp)
  print(unit_2.name, " tem hp ", unit_2.hp)
  print()]]

  if math.abs(atk_speed_1 - atk_speed_2) >= 4 then
    if atk_speed_1 > atk_speed_2 then
      return 1 --Unidade 1 realizará um segundo ataque
    else
      return 2 --Unidade 2 realizará um segundo ataque
    end
  end
  return false --Se não entrar em nenhum dos casos, não houve double attack
end


function COMBATE.acerto(unit_1, unit_2, weapons, random1, random2)
  --[[ Função que recebe como entrada duas listas de stats de duas unidades em
  combate (unidade 1 ataca e unidade 2 defende); uma lista com as armas e seus
  atriburos e dois números pseudoaleatórios (entre 1 e 100).
  Retorna 1 se o ataque da unidade 1 acertar, ou 0 se errar.
  ]]
  print("ACERTO: random1 = ", random1, ", random2 = ", random2)
  local weapon_1 = unit_1.weapon --pega a arma da unidade 1
  local weapon_2 = unit_2.weapon --pega a arma da unidade 2

  local weapon_1_type = weapons[weapon_1].kind --pega tipo de arma da unidade 1
  local weapon_2_type = weapons[weapon_2].kind --pega tipo de arma da unidade 2

  local atk_speed_2 = unit_2.spd - math.max(0, weapons[weapon_2].wt - unit_2.str) --attack speed do defensor
  print("atk_speed_2 = ", atk_speed_2)

  local triangle = triangle_bonus_table[weapon_1_type][weapon_2_type]
  local acc = weapons[weapon_1].hit + unit_1.skl * 2 + unit_1.lck + triangle * 10 --accuracy do atacante
  local avo = atk_speed_2 * 2 + unit_2.lck --avoid do defensor

  print("triangle = ", triangle)
  print("acc = ", acc)
  print("avo = ", avo)

  local hit_chance = math.max(0, math.min(100, acc - avo)) --cálculo da hit chance do ataque

  print("(random1 + random2)/2", (random1+random2)/2)
  if (random1 + random2)/2 <= hit_chance then
    print("acertou miseraaaaaaaaaaaaaaaaaaaaaaaaavi")
    return 1 --ataque acertou

  end
  print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrou")
  return 0 --ataque errou
end


function COMBATE.critical(unit_1, unit_2, weapons, random1)
  --[[ Função que recebe como entrada duas listas de stats de duas unidades em
  combate (unidade 1 ataca e unidade 2 defende); uma lista com as armas e seus
  atriburos e um número pseudoaleatório (entre 1 e 100).
  Retorna 1 se o ataque da unidade 1 for crítico, ou 0 se não.
  ]]
  local weapon_1 = unit_1.weapon --pega a arma da unidade 1

  local critical_rate = weapons[weapon_1].crt + (unit_1.skl/2) --critical rate da unidade 1
  local dodge = unit_2.lck --dodge da unidade 2

  local critical_chance = math.max(0, math.min(100, critical_rate - dodge))

    --[[print("CRITICAL random1 = ", random1)
    print("critical rate = ", critical_rate)
    print("dodge = ", dodge)
    print("critical_chance", critical_chance)
    print("random1", random1)]]
  if random1 <= critical_rate then
    return 1 --ataque foi crítico
  else
    return 0 --ataque não foi crítico
  end
end

function COMBATE.attack(unit_1, unit_2, weapons, critical)
  --[[ Função que recebe como entrada duas listas de stats de duas unidades em
  combate (unidade 1 ataca e unidade 2 defende); uma lista com as armas e seus
  atributos e uma variável que é 1 se ataque é crítico ou 0 se não o for.
  Retorna o valor do HP da unidade defensora após o ataque executado.
  ]]
  local weapon_1 = unit_1.weapon --pega a arma da unidade 1
  local weapon_2 = unit_2.weapon --pega a arma da unidade 2

  local weapon_1_type = weapons[weapon_1].kind --pega tipo de arma da unidade 1
  local weapon_2_type = weapons[weapon_2].kind --pega tipo de arma da unidade 2

  local oponent_life = unit_2.hp
  local eff_bonus = 1 --default é não ter nenhuma vantagem

  print("ATTACK")
  print(unit_1.name, " tem hp ", unit_1.hp)
  print(unit_2.name, " tem hp ", unit_2.hp)
  print()

  if weapons[weapon_1].eff then--verifica se tem campo eff
    --print("tem effectiveness")
    if weapons[weapon_1].eff == unit_2.trait then --verificando effectiveness bonus
      eff_bonus = 2 --arma é eficiente contra unidade defensora
      --print("Arma atacante de ", unit_1.name, " tem eficiencia adicional")
    else
      eff_bonus = 1 --arma não tem eficiência adicional contra unidade defensora
      --print("Arma atacante de ", unit_1.name, " nao tem eficiencia adicional")
    end
  end

  local critical_bonus = 1 --default é não ser ataque crítico
  if critical == 1 then --calculando bônus de ataque crítico
    print("Tem critical")
    critical_bonus = 3 --há dano crítico
  else
    print("Nao tem critical")
    critical_bonus = 1 --não há dano crítico
  end

  --Verificando se a arma dá dano físico:
  local armas_fisicas = {"sword", "axe", "lance", "bow"} --armas que dão ataque físico
  local sim_fisico = 0 --flag que é 1 se dano é físico e 0 se é mágico
  for index, value in ipairs(armas_fisicas) do
    if value == weapon_1_type then
      sim_fisico = 1 --dano é físico
      print("arma com  dano fisico")
    end
  end
  if(sim_fisico == 0) then
    print("arma sem dano fisico")
  end
  --
  local triangle = triangle_bonus_table[weapon_1_type][weapon_2_type]
  print("triangle = ", triangle)

  if sim_fisico == 1 then --ataque físico
    local physical_power = unit_1.str + (weapons[weapon_1].mt + triangle) * eff_bonus
    local physical_damage = (physical_power - unit_2.def) * critical_bonus --dano físico

    print("str = ", unit_1.str, ", mt = ", weapons[weapon_1].mt, "triangle = ", triangle, "eff_bonus", eff_bonus)
    print("poder e dano fisicos= ", physical_power, physical_damage)
    oponent_life = math.max(0, oponent_life - physical_damage) --se dano for maior que a vida, não permite vida negativa

  else --ataque mágico
    local magical_power = unit_1.mag + (weapons[weapon_1].mt + triangle) * eff_bonus
    local magical_damage = (magical_power - unit_2.res) * critical_bonus --dano mágico
    --calcular ataque mágico
    print("magia = ", unit_1.mag)
    print("might = ", weapons[weapon_1].mt)
    print("triangle = ", triangle)
    print("effbonus = ", eff_bonus)
    print("res2 = ", unit_2.res)
    print("crt bonus = ", critical_bonus)
    print("poder e dano magicos= ", magical_power, magical_damage)


    oponent_life = math.max(0, oponent_life - magical_damage) --se dano for maior que a vida, não permite vida negativa
    print("oponent_life = ", oponent_life)
  end

  sim_fisico = 0 --reseta flag
  return oponent_life --retorna vida do oponente após ataque
end


return COMBATE
