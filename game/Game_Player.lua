Game_Player = Game_Character:extend("Game_Player")()

function Game_Player:update(dt)
  Game_Character.prototype.update(self, dt)
  if Game_Interpreter:isRunning() then
    return
  end
end

function Game_Player:setup(x, y)
  self:moveTo(x, y)
end
