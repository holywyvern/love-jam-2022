Scene_Lock = Scene_Base:extend("Scene_Lock")

function Scene_Lock.prototype:enter(prev, digits, code)
  self._digits = digits or 4
  self._code = code or self:_getRandomCode()
  self._current = 1
  self._buttons = Array()
  for i=1,self._digits do
    self._buttons:push(
      Spriteset_CodeButton(
        i, self._digits, self._spacing(),
        self:_upButtonImage(), self:_downButtonImage(), self:_digitsImage()
      )
    )
  end
  self._bg = self:_backgroundImage()
  self._selectedImg = self:_selectedImage()
  print(self._code)
end

function Scene_Lock.prototype:_spacing()
  return 16
end

function Scene_Lock.prototype:_backgroundImage()
  return Assets.graphics.backgrounds.lock
end

function Scene_Lock.prototype:_upButtonImage()
  return Assets.graphics.locks.default.button_up
end

function Scene_Lock.prototype:_downButtonImage()
  return Assets.graphics.locks.default.button_down
end

function Scene_Lock.prototype:_digitsImage()
  return Assets.graphics.locks.default.digits
end

function Scene_Lock.prototype:_selectedImage()
  return Assets.graphics.locks.default.cursor
end

function Scene_Lock.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  local selected = self._buttons[self._current]
  if Player:pressed('left') then
    self._current = self._current - 1
    if self._current <= 0 then
      self._current = self._digits
    end
  elseif Player:pressed('right') then
    self._current = self._current + 1
    if self._current > self._digits then
      self._current = 1
    end
  elseif selected and Player:pressed("up") then
    selected.digit = selected.digit - 1
    selected._upTime = 0.2
    if selected.digit < 0 then
      selected.digit = 9
    end
  elseif selected and Player:pressed("down") then
    selected._downTime = 0.2
    selected.digit = selected.digit + 1
    if selected.digit > 9 then
      selected.digit = 0
    end
  elseif Player:pressed("cancel") then
    Scene_Lock.result = false
    Scene_Manager:pop()
  elseif Player:pressed("accept") then
    self:_checkCode()
  end
  for button in self._buttons:iterator() do
    button:update(dt)
  end  
end

function Scene_Lock.prototype:_checkCode()
  local n = ''
  for button in self._buttons:iterator() do
    n = n .. tostring(button.digit)
  end
  n = tonumber(n, 10)
  if n == self._code then
    -- TODO: Play success SFX
    Scene_Lock.result = true
    Scene_Manager:pop()
  else
    -- TODO: Play failed SFX
  end
end

function Scene_Lock.prototype:drawUI()
  love.graphics.draw(self._bg)
  for button in self._buttons:iterator() do
    button:draw()
  end
  local selected = self._buttons[self._current]
  if selected then
    love.graphics.draw(self._selectedImg, selected.x, selected.y)
  end
end

function Scene_Lock.prototype:_getRandomCode()
  local code = ''
  for i=1,self._digits do
    code = code .. tostring(love.math.random(0, 9))
  end
  return tonumber(code, 10)
end
