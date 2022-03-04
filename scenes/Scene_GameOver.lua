Scene_GameOver = Scene_Base:extend("Scene_GameOver")

function Scene_GameOver.prototype:constructor()
  Scene_Base.prototype.constructor(self)
  Audio_Manager:playBGM("game_over")
  self._img = Assets.graphics.title.back
  self._timeout = 5
  self._opacity = 0
  self._font = Assets.fonts.silver(64)
  self.update = self.updateEnter
end

function Scene_GameOver.prototype:updateEnter(dt)
  Scene_Base.prototype.update(self, dt)
  if self._opacity < 1 then
    self._opacity = math.min(1, self._opacity + dt)
    return
  end
  self.update = self.updateTimeout
end

function Scene_GameOver.prototype:updateExit(dt)
  Scene_Base.prototype.update(self, dt)
  if self._opacity > 1 then
    self._opacity = math.max(0, self._opacity - dt * 0.3)
    return
  end
  Scene_Manager:enter(Scene_Title())
end

function Scene_GameOver.prototype:updateTimeout(dt)
  Scene_Base.prototype.update(self, dt * 0.3)
  self._timeout = self._timeout - dt
  if self._timeout <= 0 then
    self.update = self.updateExit
  end
end

function Scene_GameOver.prototype:drawUI()
  love.graphics.setColor(1, 1, 1, self._opacity)
  -- love.graphics.draw(self._img)
  local w = self._font:getWidth("Game Over")
  local x = (Game_Camera.width - w) / 2
  love.graphics.setFont(self._font)
  love.graphics.print("Game Over", x, 16)
end
