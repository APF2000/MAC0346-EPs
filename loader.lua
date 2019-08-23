
local LOADER = {}

function LOADER.addPath(path)
  package.path = string.format("%s/?.lua;%s/init.lua;%s", path, path,
                               package.path)
end

function LOADER.load(path)
  local chunk = assert(loadfile(path))
  setfenv(chunk, {})
  return chunk()
end

return LOADER

