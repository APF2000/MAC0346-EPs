local AUXLOADER = {}

function AUXLOADER.format(name)
  return string.format("maps/%s", name)
end

function AUXLOADER.blocks(map)
  local index = 0
  local dimMax = {200, 200}

  local tilesets = map.tilesets[1]

  local columns = tilesets.columns
  local tileH = tilesets.tileheight
  local tileW = tilesets.tilewidth

  local startX = 0
  local startY = 0

  if(index / columns <= 5) then
    startX = tileW * (index % columns)
    startY = tileH * (index / columns)
  else
    local newIndex = index - columns*5
    startX = tileW * ((newIndex) % 10)
    startY = tileH * ((newIndex) / 10 + 5)
  end

  return love.graphics.newQuad(startX, startY, tileW, tileH, dimMax)
end

function AUXLOADER.load(path)
  local chunk = assert(loadfile(path))
  setfenv(chunk, {})
  return chunk()
end

return AUXLOADER
