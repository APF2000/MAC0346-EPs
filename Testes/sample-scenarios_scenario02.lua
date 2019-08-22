
-- luacheck: no global
--
-- Shinon kills Marcia in one hit due to weapon efficacy

return {
  input = {
    seed = 0,
    units = {
      Shinon = {
        hp = 32, str = 9, mag = 6, skl = 15,
        spd = 13, lck = 9, def = 9, res = 6,
        weapon = "steel bow"
      },
      Marcia = {
        hp = 20, str = 8, mag = 0, skl = 7,
        spd = 11, def = 4, res = 6, lck = 0,
        weapon = "slim lance", trait = "flying"
      },
    },
    weapons = {
      ["steel bow"] = { kind = "bow", mt = 9, hit = 70, crt = 0, wt = 9,
                        eff = "flying" },
      ["slim lance"] = { kind = "lance", mt = 4, hit = 85, crt = 5, wt = 6 },
    },
    fights = {
      { "Shinon", "Marcia" },
    }
  },
  output = {
    units = {
      Shinon = {
        hp = 32
      },
      Marcia = {
        hp = 0
      }
    },
  }
}

