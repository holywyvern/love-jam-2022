Scene_AudioTest = Scene_Base:extend("Scene_AudioTest")

local function basename(str)
	return string.gsub(str, "(%w+)%.(%w+)", "%1")
end

function Scene_AudioTest.prototype:constructor()
  Scene_Base.prototype.constructor(self)
  self._bgm = self:_findBGM()
  self._sfx = self:_findSFX()
  self._selectedSFX = 1
  self._selectedBGM = 1
  self._selected = 1
  self._font = Assets.fonts.silver(Game_Camera.tileSize)
end

function Scene_AudioTest.prototype:_findBGM()
  return love.filesystem.getDirectoryItems("assets/audio/bgm") or {}
end

function Scene_AudioTest.prototype:_findSFX()
  return love.filesystem.getDirectoryItems("assets/audio/sfx") or {}
end

function Scene_AudioTest.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  if self._selected == 2 then
    self:_updateBGMSelection(dt)
  else
    self:_updateSFXSelection(dt)
  end
end

function Scene_AudioTest.prototype:_updateBGMSelection(dt)
  if Player:pressed("left") then
    self._selectedBGM = self._selectedBGM - 1
    if self._selectedBGM < 1 then
      self._selectedBGM = #self._bgm
    end
  elseif Player:pressed("right") then
    self._selectedBGM = self._selectedBGM + 1
    if self._selectedBGM > #self._bgm then
      self._selectedBGM = 1
    end  
  elseif Player:pressed("up") or Player:pressed("down") then
    self._selected = 1
  elseif Player:pressed("accept") then
    local bgmName = basename(self._bgm[self._selectedBGM] or "")
    if #bgmName > 0 then
      Audio_Manager:playBGM(bgmName)
    end
  elseif Player:pressed("cancel") then
    Scene_Manager:pop()
  end
end

function Scene_AudioTest.prototype:_updateSFXSelection(dt)
  if Player:pressed("left") then
    self._selectedSFX = self._selectedSFX - 1
    if self._selectedSFX < 1 then
      self._selectedSFX = #self._sfx
    end
  elseif Player:pressed("right") then
    self._selectedSFX = self._selectedSFX + 1
    if self._selectedSFX > #self._sfx then
      self._selectedSFX = 1
    end
  elseif Player:pressed("up") or Player:pressed("down") then
    self._selected = 2
  elseif Player:pressed("accept") then
    local sfxName = basename(self._sfx[self._selectedSFX] or "")
    if #sfxName > 0 then
      Audio_Manager:playSFX(sfxName)
    end
  elseif Player:pressed("cancel") then
    Scene_Manager:pop()
  end
end

function Scene_AudioTest.prototype:drawUI()
  local ts = Game_Camera.tileSize
  local p = ts / 4
  local h = ts * 3 + p * 2
  local y = (Game_Camera.height - h) / 2
  love.graphics.setFont(self._font)
  love.graphics.setColor(1, 1, 0, 1)
  local w = self._font:getWidth("Audio Test")
  love.graphics.print("Audio Test", (Game_Camera.width - w) / 2, y)
  if self._selected == 1 then
    love.graphics.setColor(1, 0, 0, 1)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end
  local text = "<- SFX: " .. tostring(self._selectedSFX) .. ' ->'
  w = self._font:getWidth(text)
  love.graphics.print(text, (Game_Camera.width - w) / 2, y + ts + p)
  if self._selected == 2 then
    love.graphics.setColor(1, 0, 0, 1)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end
  text = "<- BGM: " .. tostring(self._selectedBGM) .. ' ->'
  w = self._font:getWidth(text)
  love.graphics.print(text,  (Game_Camera.width - w) / 2, y + ts * 2 + p * 2)
  love.graphics.setColor(1, 1, 1, 1)
end
