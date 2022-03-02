Scene_File = Scene_Base:extend("Scene_File")

function Scene_File.prototype:constructor()
  Scene_Base.prototype.constructor(self)
  self._files = Save_Manager:getFiles()
  self._font = Assets.fonts.silver(Game_Camera.tileSize)
  self._cursor = Assets.graphics.system.save_cursor
  self._selected = Save_Manager._selectedIndex or 1
  self._back = Assets.graphics.title.back
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
    Audio_Manager:playSFX("menu_select2")
  elseif Player:pressed("up") then
    self._selected = self._selected - 1
    if self._selected < 1 then
      self._selected = Save_Manager.MAX_FILES
    end
    Audio_Manager:playSFX("menu_select2")
  end
end

function Scene_File.prototype:drawUI()
  love.graphics.draw(self._back)
  local w = Game_Camera.width - Game_Camera.tileSize * 4
  local h = Game_Camera.tileSize + Game_Camera.tileSize / 2
  local p = Game_Camera.tileSize / 4
  Slog.frame.draw("default", (Game_Camera.width - w) / 2, 0, w, h)
  love.graphics.setFont(self._font)
  love.graphics.print(self:helperText(), 2 * p + (Game_Camera.width - w) / 2, p)
  for i=1,Save_Manager.MAX_FILES do
    self:_drawFile(i)
  end
  local x, y, w, h = self:_rectFor(self._selected)
  love.graphics.draw(self._cursor, x - 12, y + (h - 16) / 2 )
end

function Scene_File.prototype:_drawFile(i)
  local x, y, w, h = self:_rectFor(i)
  local p = Game_Camera.tileSize / 4
  Slog.frame.draw("default", x, y, w, h)
  if self._files[i] then
    local f = self._files[i]
    love.graphics.setFont(self._font)
    love.graphics.print(f.name, x + p * 2, y + p)
    local text = "Play Time: " .. f.timestamp
    local tw = self._font:getWidth(text)
    love.graphics.print(text, x + w - tw - p, y + h - p * 5)
  else
    love.graphics.setFont(self._font)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    local tw, th = self._font:getWidth("(No Data)"), Game_Camera.tileSize
    love.graphics.print("(No Data)", x + (w - tw) / 2, y + (h - th) / 2)
  end
end

function Scene_File.prototype:_rectFor(i)
  local h = Game_Camera.tileSize + Game_Camera.tileSize / 2
  local p = Game_Camera.tileSize / 4
  local rh = Game_Camera.tileSize + 4 * p
  local x = h
  local w = Game_Camera.width - h * 2
  local h = (Game_Camera.height - rh) / Save_Manager.MAX_FILES
  local y = rh + (i - 1) * h
  return x, y, w, h
end

function Scene_File.prototype:onSelect(index)
end

function Scene_File.prototype:onCancel()
  Scene_Manager:pop()
  Audio_Manager:playSFX("menu_back")
end

function Scene_File.prototype:helperText()
  return ""
end
