Scene_Base = Object:extend("Scene_Base")

function Scene_Base.prototype:constructor()
  self._canvas = love.graphics.newCanvas(Game_Camera.width, Game_Camera.height)
end

function Scene_Base.prototype:enter(previous)
end

function Scene_Base.prototype:pause(next, ...)
  self:leave(next, ...)
end

function Scene_Base.prototype:resume(prev, ...)
  self:enter(prev, ...)
end

function Scene_Base.prototype:update(dt)
  Player:update()
  self:_updateBasicGame(dt)
end

function Scene_Base.prototype:_updateBasicGame(dt)
  Message_Manager:update(dt)
  Game_System:update(dt)
  Game_Camera:update(dt)  
end

function Scene_Base.prototype:leave(next)
end

function Scene_Base.prototype:draw()
  love.graphics.setCanvas(self._canvas)
    love.graphics.clear()
    Game_Camera:push()
      self:drawObjects()
    Game_Camera:pop()  
    self:drawUI()
    Message_Manager:draw()
  love.graphics.setCanvas()
  self:drawCanvas()
end

function Scene_Base.prototype:drawUI()
end

function Scene_Base.prototype:drawObjects()
end

function Scene_Base.prototype:drawCanvas()
  Game_Camera:beginRender()
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self._canvas, -Game_Camera.width / 2, -Game_Camera.height / 2)
    love.graphics.setBlendMode('alpha')
  Game_Camera:endRender()
end

function Scene_Base.prototype:joystickadded(joystick)
  local index = joystick:getConnectedIndex()
  if index == 1 then
    Player.config.joystick = joystick
  end
end

function Scene_Base.prototype:resize(w, h)
end

function Scene_Base.prototype:keypressed(key)
  if key == 'f5' then
    Scene_Manager:push(Scene_AudioTest())
  end
end