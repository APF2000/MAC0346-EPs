--luacheck: globals love

local AUXLOADER = {}

function AUXLOADER.format(pathName, fileName, extension)
  return string.format("%s/%s%s", pathName, fileName, extension)
end

function AUXLOADER.blocks(MAP, index)
  local tilesets = MAP.tilesets[1]

  local columns = tilesets.columns
  local tileH = tilesets.tileheight
  local tileW = tilesets.tilewidth

  local startX = tileW * (index % columns)
  local startY = tileH * math.floor(index / columns)

  return startX, startY, tileW, tileH
end

local function framesTable(obj)
  local i = 1
  local frames = {}
  for frame_token in obj.properties.frames:gmatch("%d+") do
    frames[i] = tonumber(frame_token)
    i = i + 1
  end
  frames["current"] = 1
  frames["total"] = i - 1

  obj.newTime, obj.oldTime = 0, 0
  obj.properties.frames = frames
end

function AUXLOADER.spriteQuads(MAP)
  local layers = MAP.layers
  local spr = {}

  for _, layer in ipairs(layers) do
    if(layer.type == "objectgroup") then

      for _, obj in ipairs(layer.objects) do
        if(obj.type == "sprite") then

          --Trocando os frames de string para table
          framesTable(obj)

          local prop = obj.properties

          local format = AUXLOADER.format("chars", obj.name, ".png")

          local img = love.graphics.newImage(format)
          local columns = prop.columns
          local rows = prop.rows

          local dimw, dimh = img:getDimensions()
          local w = math.floor(dimw / columns)
          local h = math.floor(dimh / rows)

          if spr[obj.name] == nil then
            spr[obj.name] = {}

            for k = 1, columns * rows do
              local x = w * (k % columns)
              local y = h * math.floor(k / columns)


              spr[obj.name][k] = love.graphics.newQuad(x, y, w, h, dimw, dimh)
            end
            spr[obj.name].img = img
          end
        end
      end
    end
  end

  return spr
end

function AUXLOADER.objects(layers)
  local sprites, cameras = {}, {}

  for _, layer in ipairs(layers) do
    if(layer.type == "objectgroup") then

      local spriteIndex = 1
      for _, obj in ipairs(layer.objects) do
        obj.layer = layer.name
        if(obj.type == "sprite") then
          sprites[spriteIndex] = obj
          spriteIndex = spriteIndex + 1
        elseif(obj.type == "camera") then
          cameras[obj.name] = obj
          print("na posicao", obj.name, " pus", obj)
        end
      end

    end
  end
  return sprites, cameras
end

return AUXLOADER
