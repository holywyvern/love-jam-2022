Assets   = nil
Baton    = require "lib.baton"
Roomy    = require "lib.roomy"
Slog     = require "lib.slog"
StalkerX = require "lib.stalker-x"
Brady    = require "lib.brady"
-- Player is created when the application loads
Player = nil

local STARTING_MAP = "test-map"
local STARTING_POSITION = { 1, 1 }

-- Game dependencies
require "core"
require "utils"
-- Game Objects
require "managers"
require "game"
require "scenes"
-- Drawable objects
require "spritesets"

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

local function setupGame()
  Game_Interpreter:setup()
  Game_Switches:setup()
  Game_Variables:setup()
  Game_Camera:setup()
  Game_Map:setup(STARTING_MAP)
  Game_Player:setup(STARTING_POSITION[1], STARTING_POSITION[2])
end

local function setupScene()
  Scene_Manager:hook()
  Scene_Manager:enter(Scene_Test())
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  loadAssets()
  loadPlayer()
  setupManagers()
  setupGame()
  setupScene()
end
