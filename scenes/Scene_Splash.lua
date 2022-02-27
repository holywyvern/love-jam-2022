Scene_Splash = Scene_Base:extend("Scene_Splash")

function Scene_Splash.prototype:enter()
  self._splash = require("lib.splashes.o-ten-one")()
  self._splash.onDone = function ()
    Scene_Manager:enter(Scene_Test())
  end
end

function Scene_Splash.prototype:update(dt)
  self._splash:update(dt)
end

function Scene_Splash.prototype:draw()
  self._splash:draw()
end

function Scene_Splash.prototype:leave()
end

function Scene_Splash.prototype:keypressed()
  self._splash:skip()
end

function Scene_Splash.prototype:gamepadpressed()
  self._splash:skip()
end

function Scene_Splash.prototype:mousepressed()
  self._splash:skip()
end