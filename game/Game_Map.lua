Game_Map = {}

function Game_Map:setup(mapName)
  self.interpreter = Game_Interpreter()
  self._data = Cartographer.load("assets/data/maps/" .. mapName .. ".lua")
  local w, h = Game_Camera.width / 2, Game_Camera.height / 2
  Game_Camera.limits = Rect(w, h, self._data.width * 16 - w, self._data.height * 16 - h)
  self:_setupPolygons()
  self:_setupEvents()
  self._mapName = mapName
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

function Game_Map:_setupEvents()
  self.events = Array()
  for _, layer in ipairs(self._data.layers) do
    if layer.name == 'events' then
      self:_createEvents(layer)
    end
  end
end

function Game_Map:_createEvents(layer)
  local newLayer = Map_Event_Layer()
  for _, object in ipairs(layer.objects) do
    local type = object.type
    if type == "event" then
      local x = math.floor(object.x / 16)
      local y = math.floor(object.y / 16)
      local event = Game_Event:from(x, y, object.properties)
      self.events:push(event)
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
  self.interpreter:update(dt)
end

function Game_Map:isPassable(event, x, y)
  if x < 0 or y < 0 then
    return false
  end
  if x >= self._data.width or y >= self._data.height then
    return false
  end
  if event.walkable then
    return true
  end
  for _, layer in ipairs(self._data.layers) do
    if layer.type == "tilelayer" then
      local id = layer:getTileAtGridPosition(x, y)
      if id and self._data:getTileProperty(id, 'solid') then
        return false
      end
    end
  end
  for event in self:eventsAt(x, y):iterator() do
    if not event.walkable then
      return false
    end
  end
  if Game_Player._position.x == x and Game_Player._position.y == y then
    return Game_Player.walkable
  end  
  return true
end

function Game_Map:eventsAt(x, y)
  local result = Array()
  for event in self.events:iterator() do
    if event._position.x == x and event._position.y == y then
      result:push(event)
    end
  end
  return result
end

function Game_Map:findPathFor(event, goal)
  local function canWalk(x, y)
    if event._position.x == x and event._position.y == y then
      return true
    end
    if goal.x == x or goal.y == y then
      return true
    end
    return Game_Map:isPassable(event, x, y)
  end
  return LuaStar:find(
    self._data.width, self._data.height,
    event._position, goal,
    canWalk, false, true
  )
end

function Game_Map:save()
  return { name = self._mapName }
end

function Game_Map:load(data)
  self:setup(data.name)
end
