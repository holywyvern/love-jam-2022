Assets = require("lib.cargo")
Baton = require("lib.baton")
-- Player is created when the application loads
Player = nil

function love.load()
  Player = Baton.new {
    controls = {
      left = {'key:left', 'axis:leftx-', 'button:dpleft'},
      right = {'key:right', 'axis:leftx+', 'button:dpright'},
      up = {'key:up', 'axis:lefty-', 'button:dpup'},
      down = {'key:down', 'axis:lefty+', 'button:dpdown'},
      accept = {'key:x', 'button:a'},
      cancel = {'key:z', 'button:b'}
    },
    pairs = {
      move = {'left', 'right', 'up', 'down'}
    },
    joystick = love.joystick.getJoysticks()[1],
  }
end

function love.update(dt)
  Player:update()
end

function love.draw()
end

function love.joystickadded(joystick)
  local index = joystick:getConnectedIndex()
  if index == 1 then
    Player.config.joystick = joystick
  end
end
