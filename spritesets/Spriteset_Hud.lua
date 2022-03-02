Spriteset_Hud = Object:extend("Spriteset_Hud")

function Spriteset_Hud.prototype:constructor()
  self._hp = Assets.graphics.hud.hp_bar
  self._hpBar = Assets.graphics.hud.hp_bar_fill
  self._light = Assets.graphics.hud.light_bar
  self._lightBar = Assets.graphics.hud.light_bar_fill
  local w, h = self._hpBar:getDimensions()
  self._hpQuad = love.graphics.newQuad(0, 0, w, h, w, h)
  self._hpAmount = Game_Player.hp
  self._lightQuad = love.graphics.newQuad(0, 0, 36, 3, 36, 3)
  self:update()
end

function Spriteset_Hud.prototype:update(dt)
  if self._hpAmount < Game_Player.hp then
    self._hpAmount = self._hpAmount + 1
  elseif self._hpAmount > Game_Player.hp then
    self._hpAmount = self._hpAmount - 1
  end
  local w, h = self._hpBar:getDimensions()
  self._hpQuad:setViewport(0, 0, w * self._hpAmount / Game_Player.maxHP, h)
  self._lightQuad:setViewport(0, 0, 36 * Game_Player._candleTime / Game_Player.MAX_CANDLE_TIME, 3)
end

function Spriteset_Hud.prototype:draw()
  local offset = 2
  love.graphics.draw(self._hp, offset, offset)
  love.graphics.draw(self._hpBar, self._hpQuad, offset + 9, offset + 2)
  local x = 8
  local y = 10
  if Game_Inventory:hand() == "candle" then
    love.graphics.draw(self._light, x, y)
    love.graphics.draw(self._lightBar, self._lightQuad, x + 1, y + 1)    
  end
end
