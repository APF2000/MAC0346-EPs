
local n, seed = ...

math.randomseed(seed)

for i = 1, n do
  print(i, math.random(100))
end

