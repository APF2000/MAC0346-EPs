local LOADER = {}

function LOADER.addPath(name)
  local path = string.format("maps/%s.lua", name)
  return path
end

function LOADER.load(path)
  local chunk = assert(loadfile(path))
  setfenv(chunk, {})
  return chunk()
end

return LOADER
