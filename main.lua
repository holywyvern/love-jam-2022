Assets = nil
Baton = require("lib.baton")
Roomy = require("lib.roomy")
-- Player is created when the application loads
Player = nil

-- Game dependencies
require("core")
require("managers")

-- Game Objects
require("scenes")

local function loadAssets()
  Assets = require("lib.cargo").init("assets")
end

local function loadPlayer()
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

local function setupScene()
  Scene_Manager:hook()
  -- TODO: Setup first scene
end

function love.load()
  loadAssets()
  loadPlayer()
  setupScene()
end
