Game_Interpreter = {}

function Game_Interpreter:setup()
  self._commands = Array()
  self._processing = nil
  self._waitTime = 0
end

function Game_Interpreter:update(dt)
  self:updateWait(dt)
  if self._processing then
    self:updateCommand(dt)
    return
  end
  if self:isRunning() then
    return
  end
  if self._commands.length > 0 then
    self._processing = self._commands.shift()
    self:beginCommand()
    self:update(dt)
  else
    self._processing = nil
  end
end

function Game_Interpreter:updateWait(dt)
  if self._waitTime > 0 then
    self._waitTime = self._waitTime - dt
  end
end

function Game_Interpreter:updateCommand(dt)
  local code = self._processing.code
end

function Game_Interpreter:beginCommand()
  local code = self._processing.code
  if code == 'message' then
    Message_Manager:show(self._processing.text)
    self._processing = nil
  elseif code == 'wait' then
    self._waitTime = self._processing.time
    self._processing = nil
  elseif code == 'switch' then
    Game_Switches:set(self._processing.name, self._processing.value)
    self._processing = nil
  elseif code == 'variable' then
    Game_Switches:set(self._processing.name, self._processing.value)
    self._processing = nil
  elseif code == 'map' then
    Scene_Manager:enter(Scene_Map(), self._processing.map)
    Game_Player:moveTo(self._processing.x, self._processing.y)
    Game_Player:face(self._processing.direction)
    self._processing = nil
  end
end

function Game_Interpreter:isRunning()
  if Message_Manager:blocksInput() then
    return true
  end
  if self._processing then
    return true
  end
  if self._waitTime > 0 then
    return
  end
  return false
end

function Game_Interpreter:message(text)
  self._commands:push({ code = "message", text = text or "" })
end

function Game_Interpreter:wait(time)
  self._commands:push({ code = "wait", time = time or 0 })
end

function Game_Interpreter:switchOn(name)
  self._commands:push({ code = "switch", name = name, value = true })
end

function Game_Interpreter:switchOff(name)
  self._commands:push({ code = "switch", name = name, value = false })
end

function Game_Interpreter:changeMap(map, x, y, d)
  self._commands:push({
    code = "map",
    map = map,
    x = x,
    y = y,
    d = d or Game_Player:direction()
  })
end