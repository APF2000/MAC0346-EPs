units = {
      ["Shinon"] = {
        hp = 32, str = 9, mag = 6, skl = 15,
        spd = 13, lck = 9, def = 9, res = 6,
        weapon = "steel bow"
      }

}

weapons = {
      ["steel bow"] = { kind = "bow", mt = 9, hit = 70, crt = 0, wt = 9,
                        eff = "flying", ["a"] = "b", },
      ["slim lance"] = { kind = "lance", mt = 4, hit = 85, crt = 5, wt = 6 },
    }

print(weapons["steel bow"]["a"])
print(units.Shinon.hp)
--aaaaaaa
