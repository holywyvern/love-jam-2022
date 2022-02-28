Scene_File = Scene_Base:extend("Scene_File")

function Scene_File.prototype:constructor()
  Scene_Base.prototype.constructor(self)
  self._files = Save_Manager:getFiles()
  self._font = Assets.fonts.silver(32)
  self._cursor = Assets.graphics.system.save_cursor
  self._selected = Save_Manager._selectedIndex or 1
end

function Scene_File.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  if Player:pressed("accept") then
    self:onSelect(self._selected)
  elseif Player:pressed("cancel") then
    self:onCancel()
  elseif Player:pressed("down") then
    self._selected = self._selected + 1
    if self._selected > Save_Manager.MAX_FILES then
      self._selected = 1
    end
  elseif Player:pressed("up") then
    self._selected = self._selected - 1
    if self._selected < 1 then
      self._selected = Save_Manager.MAX_FILES
    end
  end
end

function Scene_File.prototype:drawUI()
  Slog.frame.draw("default", 64, 0, Game_Camera.width - 64 * 2, 32 + 8 * 2)
  love.graphics.setFont(self._font)
  love.graphics.print(self:helperText(), 72, 8)
  for i=1,Save_Manager.MAX_FILES do
    self:_drawFile(i)
  end
  local x, y, w, h = self:_rectFor(self._selected)
  love.graphics.draw(self._cursor, x - 24, y + (h - 32) / 2 )
end

function Scene_File.prototype:_drawFile(i)
  local x, y, w, h = self:_rectFor(i)
  Slog.frame.draw("default", x, y, w, h)
  if self._files[i] then
    local f = self._files[i]
    love.graphics.setFont(self._font)
    love.graphics.print(f.name, x + 8, y + 8)
    local text = "Play Time: " .. f.timestamp
    local tw = self._font:getWidth(text)
    love.graphics.print(text, x + w - tw - 8, y + h - 40)
  else
    love.graphics.setFont(self._font)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    local tw, th = self._font:getWidth("(No Data)"), 32
    love.graphics.print("(No Data)", x + (w - tw) / 2, y + (h - th) / 2)
  end
end

function Scene_File.prototype:_rectFor(i)
  local x = 64
  local w = Game_Camera.width - 64 * 2
  local h = (Game_Camera.height - 48 - 16) / Save_Manager.MAX_FILES
  local y = 48 + (i - 1) * h + 8
  return x, y, w, h
end

function Scene_File.prototype:onSelect(index)
end

function Scene_File.prototype:onCancel()
  Scene_Manager:pop()
end

function Scene_File.prototype:helperText()
  return ""
end
