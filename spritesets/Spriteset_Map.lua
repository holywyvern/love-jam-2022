Spriteset_Map = Object:extend("Spriteset_Map")

Map_Event_Layer = Object:extend("Map_Event_Layer")

function Map_Event_Layer.prototype:constructor()
  self.events = Array()
end

function Map_Event_Layer.prototype:update(dt)
  for event in self.events:iterator() do
    event:update(dt)
  end
end

function Map_Event_Layer.prototype:draw()
  for event in self.events:iterator() do
    event:draw()
  end  
end

function Spriteset_Map.prototype:constructor()
  self._layers = Array()
  for i, layer in ipairs(Game_Map:data().layers) do
    if layer.name == 'events' then
      self:createEvents(layer)
    else
      self._layers:push(layer)
    end
  end
end

function Spriteset_Map.prototype:createEvents(layer)
  local newLayer = Map_Event_Layer()
  for _, object in ipairs(layer.objects) do
    local type = object.type
    if type == "spawn" then
      local x = math.ceil(object.x / 16)
      local y = math.ceil(object.y / 16)
      local d = object.properties.direction or "down"
      -- TODO: Spawn Event
    end
  end
  newLayer.events:push(Sprite_Character(Game_Player))
  self._layers:push(newLayer)
end

function Spriteset_Map.prototype:update(dt)
  for layer in self._layers:iterator() do
    layer:update(dt)
  end
end

function Spriteset_Map.prototype:draw()
  for layer in self._layers:iterator() do
    layer:draw()
  end
end