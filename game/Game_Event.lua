Game_Event = Game_Character:extend("Game_Event")

function Game_Event.prototype:update(dt)
  Game_Character.prototype.update(self, dt)
end

function Game_Event.prototype:run()
end

function Game_Event.prototype:draw()
end

function Game_Event.prototype:trigger()
end

function Game_Event.prototype:step()
end

function Game_Event.prototype:touch()
end

function Game_Event:from(x, y, props)
  local event
  if props.template and Game_Event.templates[props.template] then
    event = Game_Event.templates[props.template](props)
  else
    event = Game_Event()
  end
  event._characterName = props.sprite or event._characterName or nil
  event.walkable = props.walkable or event.walkable or false
  event._speed = props.speed or 2
  event._standAnim = props.standAnimation or false
  event._fixDirection = props.fixDirection or false
  event:moveTo(x, y)
  event:face(props.direction or "down")
  if props.light then
    event.light = {
      radius = props['light.radius'] or 32,
      red    = props['light.red'] or 0.8,
      green  = props['light.green'] or 0.8,
      blue   = props['light.blue'] or 0.8,
      alpha  = props['light.alpha'] or 0.8,
      offset = Point(props['light.offset.x'] or 8, props['light.offset.y'] or 8)
    }
  end
  return event
end

Game_Event.templates = {
  save = require("game.events.Save_Event"),
  ["home.exit"] = require("game.events.home.Exit_Event"),
  ["home.plant"] = require("game.events.home.Plant_Event"),
  ["home.art"] = require("game.events.home.Art_Event"),
  ["home.bed"] = require("game.events.home.Bed_Event"),
  ["home.books"] = require("game.events.home.Books_Event"),
  ["home.deco"] = require("game.events.home.Deco_Event"),
  ["home.drawer"] = require("game.events.home.Drawer_Event"),
  ["home.fridge"] = require("game.events.home.Fridge_Event"),
  ["home.oven"] = require("game.events.home.Oven_Event"),
  ["home.trash"] = require("game.events.home.Trash_Event"),
  ["home.guitar"] = require("game.events.home.Guitar_Event"),
  ["home.tv"] = require("game.events.home.TV_Event"),
  teleport = require("game.events.Teleport_Event")
}
