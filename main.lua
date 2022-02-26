Assets = nil
Baton  = require "lib.baton"
Roomy  = require "lib.roomy"
Slog   = require "lib.slog"
-- Player is created when the application loads
Player = nil

-- Game dependencies
require "core"
require "managers"

-- Game Objects
require "scenes"

local function loadAssets()
  Assets = require("lib.cargo").init("assets")
  images = { frame = {} }
  images.frame.default_8 = Assets.graphics.system.frame
  Slog.frame.load()
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

local function setupManagers()
  Message_Manager:setup()
end

local function setupScene()
  Scene_Manager:hook()
  Scene_Manager:enter(Scene_Test())
end

function love.load()
  loadAssets()
  loadPlayer()
  setupManagers()
  setupScene()
end
