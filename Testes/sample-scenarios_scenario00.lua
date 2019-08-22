
-- luacheck: no global
--
-- RNG sequence:
-- 83, 85, 21, 23, 30, 28, 90, 79, 70, 63
-- Ike and the brigand both miss their attacks on Soren

return {
  input = {
    seed = 1337900143,
    units = {
      Ike = {
        hp = 50, str = 30, mag = 5, skl = 28,
        spd = 24, def = 28, res = 15, lck = 12,
        weapon = "steel blade"
      },
      Soren = {
        hp = 32, str = 14, mag = 30, skl = 32,
        spd = 28, def = 12, res = 22, lck = 16,
        weapon = "elwind"
      },
      Brigand = {
        hp = 40, str = 16, mag = 0, skl = 12,
        spd = 12, def = 10, res = 0, lck = 0,
        weapon = "iron axe"
      },
    },
    weapons = {
      ["iron axe"] = { kind = "axe", mt = 8, hit = 75, crt = 0, wt = 10 },
      ["steel blade"] = { kind = "sword", mt = 11, hit = 75, crt = 0, wt = 17 },
      ["elwind"] = { kind = "wind", mt = 4, hit = 90, crt = 0, wt = 2 },
    },
    fights = {
      { "Ike", "Soren" },
      { "Soren", "Brigand" }
    }
  },
  output = {
    units = {
      Ike = {
        hp = 12
      },
      Soren = {
        hp = 32
      },
      Brigand = {
        hp = 0
      }
    },
  }
}

