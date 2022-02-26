Scene_Map = Scene_Base:extend("Scene_Map")

function Scene_Map.prototype:enter(prev, mapId)
  self._spriteset = Spriteset_Map()
end

function Scene_Map.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  Game_Map:update(dt)
  Spriteset_Map:update(dt)
end

function Scene_Map.prototype:draw()
  love.graphics.clear()
  Game_Camera:push()
    Spriteset_Map:draw()
    Message_Manager:draw()
  Game_Camera:pop()
end
