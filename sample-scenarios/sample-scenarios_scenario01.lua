
-- luacheck: no global
--
-- RNG sequence: 62, 29, 10, 77, 56, 53, 56, 34, 6, 96
-- Mia lands a critical hit and kills the Brigand instantly

return {
  input = {
    seed = 900142,
    units = {
      Mia = {
        hp = 21, str = 7, mag = 0, skl = 10,
        spd = 13, lck = 6, def = 7, res = 2,
        weapon = "killing edge"
      },
      Brigand = {
        hp = 32, str = 10, mag = 0, skl = 6,
        spd = 4, def = 6, res = 0, lck = 0,
        weapon = "iron axe"
      },
    },
    weapons = {
      ["killing edge"] = { kind = "sword", mt = 9, hit = 75, crt = 30, wt = 9 },
      ["iron axe"] = { kind = "axe", mt = 8, hit = 75, crt = 0, wt = 10 },
    },
    fights = {
      { "Mia", "Brigand" },
    }
  },
  output = {
    units = {
      Mia = {
        hp = 21
      },
      Brigand = {
        hp = 0
      }
    },
  }
}

