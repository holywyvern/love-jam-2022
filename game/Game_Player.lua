Game_Player = Game_Character:extend("Game_Player")()

Game_Player.maxHP = 100
Game_Player.hp = Game_Player.maxHP
Game_Player._characterName = "player"
Game_Camera.follower = Game_Player._realPosition

local MAX_CANDLE_TIME = 60 

Game_Player.MAX_CANDLE_TIME = MAX_CANDLE_TIME
Game_Player._candleTime = MAX_CANDLE_TIME
Game_Player._candleWobble = 0

function Game_Player:heal()
  self.hp = self.maxHP
end

function Game_Player:isDead()
  return self.hp <= 0
end

function Game_Player:update(dt)
  Game_Character.prototype.update(self, dt)
  if Game_Inventory:hand() == "candle" then
    self:updateCandle(dt)
  end
  if Game_Inventory.menuOpen then
    self:updateMenu()
    return
  end
  if not self:canInput() then
    return
  end
  self:updateInput()
end

function Game_Player:updateCandle(dt)
  self._candleTime = self._candleTime - dt
  if self._candleTime < 0 then
    self._candleTime = MAX_CANDLE_TIME
    self.light = nil
    Game_Inventory.selection = 1
    Game_Inventory:consume("candle")
  else
    self._candleWobble = self._candleWobble + dt * 5
    local r = 59 + self._candleTime * 5 / MAX_CANDLE_TIME
    self.light.radius =  r + math.sin(self._candleWobble)
  end
end

function Game_Player:canInput()
  local blocked = Message_Manager:blocksInput() or Game_Map.interpreter:isRunning() or self.interpreter:isRunning()
  return not blocked
end

function Game_Player:updateMenu()
  if Player:pressed("cancel") then
    Game_Inventory.menuOpen = false
    Audio_Manager:playSFX("menu_back")
  elseif Player:pressed("accept") then
    Audio_Manager:playSFX("menu_select")
    Game_Inventory.menuOpen = false
    Game_Inventory.selection = Game_Inventory.currentSelection
    if Game_Inventory:hand() == 'candle' then
      self.light = {
        radius = 64,
        red = 1,
        green = 0.8,
        blue = 0.7,
        alpha = 0.3,
        offset = Point(8, 8)
      }
    else
      self.light = nil
    end
  elseif Player:pressed("left") then
    if Game_Inventory.currentSelection == 1 then
      Game_Inventory.currentSelection = 6
    elseif Game_Inventory.currentSelection == 7 then
      Game_Inventory.currentSelection = 12
    else
      Game_Inventory.currentSelection = Game_Inventory.currentSelection - 1
    end
  elseif Player:pressed("right") then
    if Game_Inventory.currentSelection == 6 then
      Game_Inventory.currentSelection = 1
    elseif Game_Inventory.currentSelection == 12 then
      Game_Inventory.currentSelection = 7
    else
      Game_Inventory.currentSelection = Game_Inventory.currentSelection + 1
    end
  elseif Player:pressed("up") or Player:pressed("down") then
    if Game_Inventory.currentSelection > 6 then
      Game_Inventory.currentSelection = Game_Inventory.currentSelection - 6
    else
      Game_Inventory.currentSelection = Game_Inventory.currentSelection + 6
    end
  end
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
  elseif Player:pressed("cancel") then
    Game_Inventory.menuOpen = true
    Game_Inventory.currentSelection = Game_Inventory.selection
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
    direction = self._direction,
    candleTime = self._candleTime,
    maxHP = self.maxHP
  }
end

function Game_Player:load(data)
  self:moveTo(data.x, data.y)
  self:face(data.direction)
  self._candleTime = candleTime or MAX_CANDLE_TIME
  self.maxHP = data.maxHP or 100
  self.hp = self.maxHP
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
