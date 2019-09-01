local LOADER = {}

function LOADER.format(name)
  return string.format("maps/%s", name)
end

function LOADER.block(index, MAP)
  
  local dimMax = img:getDimensions()

  local tilesets = MAP.tilesets[1]

  local columns = tilesets.columns
  local tileH = tilesets.tileheight
  local tileW = tilesets.tilewidth

  local startX = 0
  local startY = 0
  return love.graphics.newQuad(startX, startY, tileW, tileH, dimMax)
end

function LOADER.load(path)
  local chunk = assert(loadfile(path))
  setfenv(chunk, {})
  return chunk()
end

return LOADER
