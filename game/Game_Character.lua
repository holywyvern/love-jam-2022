Game_Character = Object:extend("Game_Character")

local FRAMES = {1, 0, 1, 2}

function Game_Character.prototype:constructor()
  self.interpreter = Game_Interpreter()
  self._characterName = nil
  self._direction = 2
  self._anim = 1
  self._animTime = 0.3
  self._animDelay = 0.3
  self._speed = 2
  self._standAnim = false
  self._walkAnim = true
  self._position = Point()
  self._realPosition = Point()
  self._targetPosition = Point()
  self._fixDirection = false
  self.walkable = false
  self._moveBuffer = 0
end


function Game_Character.prototype:update(dt)
  self:updateMovement(dt)
  self:updateAnimation(dt)
  self:updateFollower(dt)
end

function Game_Character.prototype:updateMovement(dt)
  if self._moveBuffer > 0 then
    self._moveBuffer = self._moveBuffer - dt
  end
  local minx = math.min(self._realPosition.x, self._targetPosition.x)
  local miny = math.min(self._realPosition.y, self._targetPosition.y)
  local maxx = math.max(self._realPosition.x, self._targetPosition.x)
  local maxy = math.max(self._realPosition.y, self._targetPosition.y)
  local tx, ty = 0, 0
  if self._realPosition.x > self._targetPosition.x then
    tx = -1
  elseif self._realPosition.x < self._targetPosition.x then
    tx = 1
  end
  if self._realPosition.y > self._targetPosition.y then
    ty = -1
  elseif self._realPosition.y < self._targetPosition.y then
    ty = 1
  end
  local dx = 16 * dt * self._speed * tx
  local dy = 16 * dt * self._speed * ty
  local x = math.min(maxx, math.max(minx, self._realPosition.x + dx))
  local y = math.min(maxy, math.max(miny, self._realPosition.y + dy))
  local wasMoving = self:isMoving()
  self._realPosition:set(x, y)
  if wasMoving and not self:isMoving() then
    self._moveBuffer = 0.2
  end
end

function Game_Character.prototype:updateAnimation(dt)
  if not self:isAnimating() then
    self._anim = 1
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

function Game_Character.prototype:updateFollower()
  if not self.follower then
    return
  end
  if self:isMoving() then
    return
  end
  if self._followerStep then
    local pos = self._followerStep
    self:faceAt(pos.x, pos.y)
    local d = math.abs(pos.x - self._position.x) + math.abs(pos.y - self._position.y)
    if d == 1 and Game_Map:isPassable(self, pos.x, pos.y) then
      self._targetPosition:set(pos.x * 16, pos.y * 16)
      self._position:set(pos.x, pos.y)
    end
    self._followerStep = nil
    return
  end
  local path = Game_Map:findPathFor(self, self.follower._position)
  if path then
    self._followerStep = path[2]
  end 
end

function Game_Character.prototype:moveTo(x, y)
  self._position:set(x, y)
  self._realPosition:set(x * 16, y * 16)
  self._targetPosition:copy(self._realPosition)
end

function Game_Character.prototype:move(direction)
  if not self._fixDirection then
    self:face(direction)
  end
  local dir = self:_directionOf(direction)
  local x, y = self._position:get()
  if dir == 2 then
    y = y + 1
  elseif dir == 4 then
    x = x - 1
  elseif dir == 6 then
    x = x + 1
  elseif dir == 8 then
    y = y - 1
  end
  if Game_Map:isPassable(self, x, y) then
    self._position:set(x, y)
    self._targetPosition:set(x * 16, y * 16)
  end
end



function Game_Character.prototype:isAnimating()
  local isMoving = self:isMoving() or self._moveBuffer > 0
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
  self._direction = self:_directionOf(direction)
end

function Game_Character.prototype:_directionOf(direction)
  if type(direction) == "number" then
    return direction
  elseif direction == "up" or direction == "u" then
    return 8
  elseif direction == "down" or direction == "d" then
    return 2
  elseif direction == "left" or direction == "l" then
    return 4
  elseif direction == "right" or direction == "r" then
    return 6
  end
  return 2
end

function Game_Character.prototype:direction()
  return self._direction
end

function Game_Character.prototype:frame()
  return FRAMES[self._anim]
end

function Game_Character.prototype:faceAt(x, y)
  if x > self._position.x then
    self:face("right")
  elseif x < self._position.x then
    self:face("left")
  elseif y > self._position.y then
    self:face("down")
  elseif y < self._position.y then
    self:face("up")
  end
end
