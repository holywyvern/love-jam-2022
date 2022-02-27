Game_Player = Game_Character:extend("Game_Player")()

Game_Player._characterName = "player"

Game_Camera.follower = Game_Player._realPosition

function Game_Player:update(dt)
  Game_Character.prototype.update(self, dt)
  if Game_Interpreter:isRunning() then
    return
  end
  self:updateInput()
end

function Game_Player:updateInput()
  if self:isMoving() then
    return
  end
  local x, y = Player:get("move")
  if y > 0 then
    self:move("down")
  elseif y < 0 then
    self:move("up")
  elseif x > 0 then
    self:move("right")
  elseif x < 0 then
    self:move("left")
  end
end

function Game_Player:setup(x, y)
  self:moveTo(x, y)
end
