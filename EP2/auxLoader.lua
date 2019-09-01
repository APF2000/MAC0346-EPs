local AUXLOADER = {}

function AUXLOADER.format(name)
  return string.format("maps/%s", name)
end

function AUXLOADER.result(MAP, index)
  local tilesets = MAP.tilesets[1]

  local columns = tilesets.columns
  local tileH = tilesets.tileheight
  local tileW = tilesets.tilewidth

  local startX = 0
  local startY = 0

  startX = tileW * (index % columns)
  startY = tileH * math.floor(index / columns)

  return startX, startY, tileW, tileH
end

function AUXLOADER.load(path)
  local chunk = assert(loadfile(path))
  setfenv(chunk, {})
  return chunk()
end

return AUXLOADER
