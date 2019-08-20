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
  local weapon_1 = unit_1.weapon
  local weapon_2 = unit_2.weapon
  local atk_speed_1 = unit_1.spd - math.max(0, weapons[weapon_1].wt - unit_1.str)
  local atk_speed_2 = unit_2.spd - math.max(0, weapons[weapon_2].wt - unit_2.str)

  if math.abs(atk_speed_1 - atk_speed_2) >= 4 then
    if atk_speed_1 > atk_speed_2 then
      return 1 --Unidade 1 realizará um segundo ataque
    else
      return 2 --Unidade 2 realizará um segundo ataque
    end
  end
  return 0 --Se não entrar em nenhum dos casos, não houve double attack
end

function COMBATE.acerto(unit_1, unit_2, weapons)
  --[[ Função que recebe como entrada duas listas de stats de duas unidades em
  combate (unidade 1 ataca e unidade 2 defende) e uma lista com as armas e seus
  atriburos.
  Retorna 1 se o ataque da unidade 1 acertar, ou 0 se errar.
  ]]

  --implementar

end

-- falta fazer uma função de acerto crítico e outra de dano!

return COMBATE
