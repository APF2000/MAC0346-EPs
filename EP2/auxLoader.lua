local AUXLOADER = {}

function AUXLOADER.format(pathName, fileName, extension)
  return string.format("%s/%s%s", pathName, fileName, extension)
end

function AUXLOADER.blocks(MAP, index)
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

function AUXLOADER.sprites(MAP)
  local layers = MAP.layers
  local x, y, w, h = 0, 0, 0, 0
  local spr = {}

  for i, layer in ipairs(layers) do
    if(layer.type == "objectgroup") then

      for j, obj in ipairs(layer.objects) do
        if(obj.type == "sprite") and (spr[obj.name] == nil) then
          local prop = obj.properties

          local format = AUXLOADER.format("chars", obj.name, ".png")

          local img = love.graphics.newImage(format)
          print("img", img)
          local columns = prop.columns
          local rows = prop.rows

          local dimw, dimh = img:getDimensions()
          w = math.floor(dimw / columns)
          h = math.floor(dimh / rows)

          local offsetx = prop.offsetx
          local offsety = prop.offsety


            spr[obj.name] = {}

            for k = 1, columns * rows do
              x = w * (k % columns)
              y = h * math.floor(k / columns)
              print("x, y", x, y)

              spr[obj.name][k] = love.graphics.newQuad(x, y, w, h, dimw, dimh)
            end
            spr[obj.name].img = img

        end
      end
    end
  end

  print("imgreturn", img)
  print()
  return spr, img
end

return AUXLOADER
