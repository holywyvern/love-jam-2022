Spriteset_Map = Object:extend("Spriteset_Map")

Map_Event_Layer = Object:extend("Map_Event_Layer")

function Map_Event_Layer.prototype:constructor()
  self.events = Array()
end

function Map_Event_Layer.prototype:update(dt)
  for event in self.events:iterator() do
    event:update(dt)
  end
  self.events:sort(
    function (a, b)
      return a.position.y > b.position.y
    end
  )
end

function Map_Event_Layer.prototype:draw()
  for event in self.events:iterator() do
    event:draw()
  end  
end

function Spriteset_Map.prototype:constructor()
  self._layers = Array()
  self._lighter = Lighter()
  local data = Game_Map:data()
  self._lightCanvas = love.graphics.newCanvas(data.width * 16, data.height * 16)  
  for i, layer in ipairs(data.layers) do
    if layer.name == 'events' then
      self:createEvents(layer)
    else
      self._layers:push(layer)
    end
  end
  for poly in Game_Map._polygons:iterator() do
    self._lighter:addPolygon(poly)
  end
end

function Spriteset_Map.prototype:createEvents(layer)
  local newLayer = Map_Event_Layer()
  for _, object in ipairs(layer.objects) do
    local type = object.type
    if type == "light" then
      local props = object.properties
      local x = object.x or 0
      local y = object.y or 0
      local rad = props.radius or 32
      local r = props.red or 0.8
      local g = props.green or 0.8
      local b = props.blue or 0.8
      local a = props.alpha or 0.6
      self._lighter:addLight(x, y, rad, r, g, b, a)
    end
  end
  newLayer.events:push(Sprite_Character(Game_Player, self._lighter))
  for event in Game_Map.events:iterator() do
    local sprite = Sprite_Character(event, self._lighter)
    newLayer.events:push(sprite)
    if event.light then
      local light = event.light
      local x, y = event._realPosition:get()
      local ox, oy = light.offset:get()
      sprite.light = self._lighter:addLight(
        x + ox, y + oy,
        light.radius, light.red, light.green, light.blue, light.alpha
      )
    end
  end
  self._layers:push(newLayer)
end

function Spriteset_Map.prototype:update(dt)
  for layer in self._layers:iterator() do
    layer:update(dt)
  end
  self:updateLights(dt)
end

function Spriteset_Map.prototype:updateLights(dt)
  love.graphics.setCanvas({ self._lightCanvas, stencil = true})
    local data = Game_Map:data()
    local r = data.properties['ambient.red'] or 0.1
    local g = data.properties['ambient.green'] or 0.1
    local b = data.properties['ambient.blue'] or 0.1
    local a = data.properties['ambient.alpha'] or 0.8
    love.graphics.clear(r, g, b, a) -- Global illumination level
    self._lighter:drawLights()
  love.graphics.setCanvas()    
end

function Spriteset_Map.prototype:draw()
  for layer in self._layers:iterator() do
    layer:draw()
  end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.draw(self._lightCanvas)
  love.graphics.setBlendMode("alpha")
end