Scene_Map = Scene_Base:extend("Scene_Map")

function Scene_Map.prototype:enter(prev, result)
  self._spriteset = Spriteset_Map()
  self._inventory = Spriteset_Inventory()
end

function Scene_Map.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  self._spriteset:update(dt)
  self._inventory:update(dt)
end

function Scene_Map.prototype:_updateBasicGame(dt)
  Game_Player:update(dt)
  Scene_Base.prototype._updateBasicGame(self, dt)
  Game_Map:update(dt)
end

function Scene_Map.prototype:drawObjects()
  self._spriteset:draw()
end

function Scene_Map.prototype:drawUI()
  self._inventory:draw()
end
