Game_Map = {}

function Game_Map:setup(mapName)
  self._data = Cartographer.load("assets/data/maps/" .. mapName .. ".lua")
  local w, h = Game_Camera.width / 2, Game_Camera.height / 2
  Game_Camera.limits = Rect(w, h, self._data.width * 16, self._data.height * 16)
  Game_Map:_setupPolygons()
end

function Game_Map:_setupPolygons()
  self._polygons = Array()
  for _, layer in ipairs(self._data.layers) do
    if layer.type == "tilelayer" then
      for x=0,self._data.width do
        for y=0,self._data.height do
          local id = layer:getTileAtGridPosition(x, y)
          if id then
            local tile = self._data:getTile(id)
            if tile and tile.objectGroup then
              for _, object in ipairs(tile.objectGroup.objects) do
                self:_addPolygon(x * 16, y * 16, object)
              end
            end
          end
        end
      end
    end
  end
end

function Game_Map:_addPolygon(x, y, object)
  if object.shape == 'rectangle' then
    self._polygons:push({
      x + object.x,
      y + object.y,
      x + object.x + object.width,
      y + object.y,
      x + object.x + object.width,
      y + object.y + object.height,
      x + object.x,
      y + object.y + object.height,
    })
  end
end

function Game_Map:data()
  return self._data;
end

function Game_Map:update(dt)
  Game_Interpreter:update(dt)
  if Game_Interpreter:isRunning() then
    return
  end
  Game_Player:update(dt)
end

function Game_Map:isPassable(x, y)
  if x < 0 or y < 0 then
    return false
  end
  if x >= self._data.width or y >= self._data.height then
    return false
  end
  for _, layer in ipairs(self._data.layers) do
    if layer.type == "tilelayer" then
      local id = layer:getTileAtGridPosition(x, y)
      if id and self._data:getTileProperty(id, 'solid') then
        return false
      end
    end
  end
  return true
end
