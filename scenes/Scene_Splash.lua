Scene_Splash = Scene_Base:extend("Scene_Splash")

function Scene_Splash.prototype:enter()
  self._splash = require("lib.splashes.o-ten-one")()
  local scene = self
  self._splash.onDone = function ()
    scene:startFadeout()    
  end
  self._alpha = 1
  self._splashCanvas = love.graphics.newCanvas(love.graphics.getDimensions())
end

function Scene_Splash.prototype:startFadeout()
  self.update = self.updateFadeout
  self.draw = self.drawFadeout
  self._alpha = 1
end

function Scene_Splash.prototype:updateFadeout(dt)
  Scene_Splash.prototype.update(self, dt)
  if self._alpha > 0 then
    self._alpha = self._alpha - dt
    self._exit = true
    return
  end
  if self._exit then
    Scene_Manager:enter(Scene_Title())
    self._exit = false
  end
end

function Scene_Splash.prototype:update(dt)
  self._splash:update(dt)
  local canvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self._splashCanvas)
    self._splash:draw()
  love.graphics.setCanvas(canvas)
end

function Scene_Splash.prototype:draw()
  love.graphics.setColor(1, 1, 1, self._alpha)
  love.graphics.draw(self._splashCanvas)
end

function Scene_Splash.prototype:drawFadeout()
end

function Scene_Splash.prototype:leave()
end

function Scene_Splash.prototype:keypressed()
  Audio_Manager:playSFX("menu_back")
  self._splash:skip()
end

function Scene_Splash.prototype:gamepadpressed()
  Audio_Manager:playSFX("menu_back")
  self._splash:skip()
end

function Scene_Splash.prototype:mousepressed()
  Audio_Manager:playSFX("menu_back")
  self._splash:skip()
end