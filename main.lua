Assets       = nil
Baton        = require "lib.baton"
Roomy        = require "lib.roomy"
Slog         = require "lib.slog"
Icon         = Slog.icon
StalkerX     = require "lib.stalker-x"
Brady        = require "lib.brady"
Cartographer = require "lib.cartographer"
-- Player is created when the application loads
Player = nil

local STARTING_MAP = "test"
local STARTING_POSITION = { 5, 4 }

-- Game dependencies
require "core"
require "utils"
-- Game Objects
require "managers"
require "game"
require "scenes"
-- Drawable objects
require "sprites"
require "spritesets"

local function loadAssets()
  Assets = require("lib.cargo").init("assets")
  Audio = Assets.audio
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
  Scene_Manager:enter(Scene_Splash())
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  loadAssets()
  loadPlayer()
  setupManagers()
  setupGame()
  setupScene()
end
