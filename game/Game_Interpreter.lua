Game_Interpreter = Object:extend("Game_Interpreter")

function Game_Interpreter.prototype:constructor()
  self._commands = Array()
  self._processing = nil
  self._waitTime = 0
end

function Game_Interpreter.prototype:update(dt)
  self:updateWait(dt)
  if self._processing then
    self:updateCommand(dt)
    return
  end
  if self:isRunning() then
    return
  end
  if self._commands.length > 0 then
    self._processing = self._commands:shift()
    self:beginCommand()
    self:update(dt)
  else
    self._processing = nil
  end
end

function Game_Interpreter.prototype:updateWait(dt)
  if self._waitTime > 0 then
    self._waitTime = self._waitTime - dt
  end
end

function Game_Interpreter.prototype:updateCommand(dt)
  local code = self._processing.code
  if code == 'move' then
    if not self._processing.event:isMoving() then
      self._processing = nil
    end
  elseif code == "waitMove" then
    if not self._processing.event:isMoving() then
      self._processing = nil
    end
  end
end

function Game_Interpreter.prototype:beginCommand()
  local code = self._processing.code
  if code == 'message' then
    Message_Manager:show(self._processing.text, self._processing.options)
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
    Game_Map:setup(self._processing.map)
    Scene_Manager:enter(Scene_Map(), self._processing.map)
    Game_Player:moveTo(self._processing.x, self._processing.y)
    Game_Player:face(self._processing.direction)
    self._processing = nil
  elseif code == 'enter' then
    local unpk = table.unpack or unpack
    Scene_Manager:enter(self._processing.scene, unpk(self._processing.args))
    self._processing = nil
  elseif code == 'move' then
    self._processing.event:move(self._processing.direction)
    if not self._processing.wait then
      self._processing = nil
    end
  elseif code == 'addItem' then
    Game_Inventory:add(self._processing.item, self._processing.amount or 1)
    self._processing = nil
  end
end

function Game_Interpreter.prototype:isRunning()
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

function Game_Interpreter.prototype:message(text, options)
  self._commands:push({ code = "message", text = text or "", options = options })
end

function Game_Interpreter.prototype:wait(time)
  self._commands:push({ code = "wait", time = time or 0 })
end

function Game_Interpreter.prototype:switchOn(name)
  self._commands:push({ code = "switch", name = name, value = true })
end

function Game_Interpreter.prototype:switchOff(name)
  self._commands:push({ code = "switch", name = name, value = false })
end

function Game_Interpreter.prototype:changeMap(map, x, y, d)
  self._commands:push({
    code = "map",
    map = map,
    x = x,
    y = y,
    d = d or Game_Player:direction()
  })
end

function Game_Interpreter.prototype:enter(scene, ...)
  self._commands:push({
    code = "enter",
    scene = scene,
    args = { ... }
  })
end

function Game_Interpreter.prototype:move(event, direction, wait)
  self._commands:push({
    code = "move",
    event = event,
    direction = direction,
    wait = wait
  })
end


function Game_Interpreter.prototype:face(event, direction)
  self._commands:push({
    code = "face",
    event = event,
    direction = direction
  })
end

function Game_Interpreter.prototype:faceAt(event, target)
  self._commands:push({
    code = "faceAt",
    event = event,
    target = target,
  })
end

function Game_Interpreter.prototype:addItem(item, amount)
  self._commands:push({
    code = "addItem",
    item = item,
    amount = amount
  })
end

function Game_Interpreter.prototype:waitForMove(event)
  self._commands:push({
    code = "waitMove",
    event = event
  })
end
