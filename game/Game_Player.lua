Game_Player = Game_Character:extend("Game_Player")

function Game_Player.prototype:constructor(x, y)
  Game_Character.prototype.constructor(self)
  self:moveTo(x, y)
end

function Game_Player:update(dt)
  Game_Character.prototype.update(self, dt)
  if Game_Interpreter:isRunning() then
    return
  end
end

function Game_Player:setup(x, y)
  self._player = self(x, y)
end

function Game_Player:update(dt)
  self._player:update(dt)
end

function Game_Player:direction()
  return self._player:direction()
end

function Game_Player:moveTo(x, y)
  self._player:moveTo(x, y)
end

function Game_Player:face(direction)
  self._player:face(direction)
end
