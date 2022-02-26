Scene_Base = Object:extend("Scene_Base")

function Scene_Base.prototype:enter(previous)
end

function Scene_Base.prototype:update(dt)
  Player:update()
end

function Scene_Base.prototype:leave(next)
end

function Scene_Base.prototype:draw(previous)
end

function Scene_Base.prototype:joystickadded(joystick)
  local index = joystick:getConnectedIndex()
  if index == 1 then
    Player.config.joystick = joystick
  end
end
