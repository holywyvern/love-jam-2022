Game_Character = Object:extend("Game_Character")

local FRAMES = {1, 0, 1, 2}

function Game_Character.prototype:constructor()
  self._characterName = nil
  self._direction = 2
  self._anim = 1
  self._animTime = 0.3
  self._animDelay = 0.3
  self._speed = 2
  self._standAnim = true
  self._walkAnim = true
  self._position = Point()
  self._realPosition = Point()
  self._targetPosition = Point()
end


function Game_Character.prototype:update(dt)
  self:updateMovement(dt)
  self:updateAnimation(dt)
end

function Game_Character.prototype:updateMovement(dt)
end

function Game_Character.prototype:updateAnimation(dt)
  if not self:isAnimating() then
    return
  end
  self._animTime = self._animTime - dt
  while self._animTime <= 0 do
    self._animTime = self._animTime + self._animDelay
    self._anim = self._anim + 1
    if self._anim > #FRAMES then
      self._anim = 1
    end
  end
end

function Game_Character.prototype:moveTo(x, y)
  self._position:set(x, y)
  self._realPosition:set(x * 16, y * 16)
  self._targetPosition:copy(self._realPosition)
end

function Game_Character.prototype:isAnimating()
  local isMoving = self:isMoving()
  if self._walkAnim and isMoving then
    return true
  end
  if self._standAnim and not isMoving then
    return true
  end
  return false
end

function Game_Character.prototype:isMoving()
  local movingX = self._realPosition.x ~= self._targetPosition.x
  local movingY = self._realPosition.y ~= self._targetPosition.y
  return movingX or movingY
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
  return self._direction
end

function Game_Character.prototype:frame()
  return FRAMES[self._anim]
end
