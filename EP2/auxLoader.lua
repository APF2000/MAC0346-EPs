local LOADER = {}

function LOADER.formatLua(name)
  return string.format("maps/%s.lua", name)
end

function LOADER.formatImage(name)
  return string.format("maps/%s", name)
end

function LOADER.load(path)
  local chunk = assert(loadfile(path))
  setfenv(chunk, {})
  return chunk()
end

return LOADER
