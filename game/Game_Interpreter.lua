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
  elseif code == 'bgm' then
    Audio_Manager:playBGM(self._processing.name)
    self._processing = nil
  elseif code == 'sfx' then
    Audio_Manager:playSFX(self._processing.name)
    self._processing = nil
  elseif code == 'stopBGM' then
    Audio_Manager:stopBGM()
    self._processing = nil
  elseif code == "save" then
    Scene_Manager:push(Scene_Save())
    self._processing = nil
  elseif code == "heal" then
    Game_Player:heal()
    self._processing = nil
  elseif code == "color" then
    self._processing.event._color = self._processing.color
    self._processing = nil
  elseif code == "walkable" then
    self._processing.event.walkable = self._processing.walkable
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

function Game_Interpreter.prototype:playSFX(name)
  self._commands:push({
    code = "sfx",
    name = name
  })
end

function Game_Interpreter.prototype:playSoundEffect(name)
  self:playSFX(name)
end

function Game_Interpreter.prototype:playBGM(name)
  self._commands:push({
    code = "bgm",
    name = name
  })
end

function Game_Interpreter.prototype:stopBGM()
  self._commands:push({
    code = "stopBGM",
  })
end

function Game_Interpreter.prototype:playMusic(name)
  self:playBGM(name)
end


function Game_Interpreter.prototype:stopMusic()
  self:stopBGM()
end

function Game_Interpreter.prototype:bgm(name)
  self:playBGM(name)
end

function Game_Interpreter.prototype:music(name)
  self:playBGM(name)
end

function Game_Interpreter.prototype:sfx(name)
  self:playSFX(name)
end

function Game_Interpreter.prototype:soundEffect(name)
  self:playSFX(name)
end

function Game_Interpreter.prototype:heal()
  self._commands:push({
    code = "heal"
  })
end

function Game_Interpreter.prototype:save()
  self._commands:push({
    code = "save"
  })
end

function Game_Interpreter.prototype:setColor(event, r, g, b, a)
  self._commands:push({
    code = "color",
    event = event,
    color = {r, g, b, a}
  })
end

function Game_Interpreter.prototype:setOpacity(event, a)
  self:setColor(event, event._color[1], event._color[2], event._color[3], a)
end

function Game_Interpreter.prototype:setWalkable(event, walkable)
  self._commands:push({
    code = "walkable",
    event = event,
    walkable = walkable or false
  })
end
