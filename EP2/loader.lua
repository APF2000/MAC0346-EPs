local LOADER = {}

function LOADER.addPath(path)
  package.path = string.format("maps/%s.lua", path)
end

function LOADER.load(path)
  local chunk = assert(loadfile(path))
  setfenv(chunk, {})
  return chunk()
end

return LOADER
