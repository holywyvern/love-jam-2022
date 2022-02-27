Game_Event = Game_Character:extend("Game_Event")

function Game_Event.prototype:update(dt)
end

function Game_Event.prototype:run()
end

function Game_Event.prototype:draw()
end

function Game_Event.prototype:trigger()
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
}
