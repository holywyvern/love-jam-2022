Game_Player = Game_Character:extend("Game_Player")()

Game_Player._characterName = "player"

Game_Camera.follower = Game_Player._realPosition

function Game_Player:update(dt)
  Game_Character.prototype.update(self, dt)
  if  Message_Manager:blocksInput() or Game_Map.interpreter:isRunning() or self.interpreter:isRunning() then
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
  if self:isMoving() then
    return
  end
  if Player:pressed("accept") then
    self:_checkEventTrigger()
  end
end

function Game_Player:_checkEventTrigger()
  local d = self:direction()
  local x, y = self._position:get()
  if d == 2 then
    y = y + 1
  elseif d == 8 then
    y = y - 1
  elseif d == 4 then
    x = x - 1
  elseif d == 6 then
    x = x + 1
  end
  local events = Game_Map:eventsAt(x, y)
  for event in events:iterator() do
    event:trigger()
  end
end

function Game_Player:_checkEventStep()
  local x, y = self._position:get()
  local events = Game_Map:eventsAt(x, y)
  for event in events:iterator() do
    event:step()
  end  
end

function Game_Player:_checkEventTouch(direction)
  local d = self:_directionOf(direction)
  local x, y = self._position:get()
  if d == 2 then
    y = y + 1
  elseif d == 8 then
    y = y - 1
  elseif d == 4 then
    x = x - 1
  elseif d == 6 then
    x = x + 1
  end
  local events = Game_Map:eventsAt(x, y)
  for event in events:iterator() do
    event:touch()
  end
end

function Game_Player:setup(x, y)
  self:moveTo(x, y)
end

function Game_Player:save()
  return {
    x = self._position.x,
    y = self._position.y,
    direction = self._direction
  }
end

function Game_Player:load(data)
  self:moveTo(data.x, data.y)
  self:face(data.direction)
end

function Game_Player:move(direction)
  Game_Character.prototype.move(self, direction)
  if self:isMoving() then
    self.interpreter:waitForMove(self)
    Game_Map.interpreter:waitForMove(self)
    self:_checkEventStep()
    self:_checkEventTouch(direction)
  end
end
