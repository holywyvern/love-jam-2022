Scene_Map = Scene_Base:extend("Scene_Map")

function Scene_Map.prototype:enter(prev, mapId)
  self._spriteset = Spriteset_Map()
end

function Scene_Map.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  Game_Map:update(dt)
  Spriteset_Map:update(dt)
end

function Scene_Map.prototype:drawObjects()
  Spriteset_Map:draw()
end
