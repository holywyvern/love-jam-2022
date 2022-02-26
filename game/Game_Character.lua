Game_Character = Object:extend("Game_Character")

function Game_Character.prototype:update(dt)
end

function Game_Character.prototype:moveTo(x, y)
end

function Game_Character.prototype:isMoving()
  return false
end

function Game_Character.prototype:face(direction)
  if type(direction) == "number" then
    self._direction = direction
  elseif direction == "up" or direction == "u" then
    self._direction = 8
  elseif direction == "down" or direction == "d" then
    self._direction = 2
  elseif direction == "left" or direction == "l" then
    self._direction = 4
  elseif direction == "right" or direction == "r" then
    self._direction = 6
  end
end

function Game_Character.prototype:direction()
  return 2
end
