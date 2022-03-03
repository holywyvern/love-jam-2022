Game_Monster = Game_Event:extend("Game_Monster")

local SPRITES = {
  'bolitas',
  'esqueletis',
  'fantasmita',
  'gordito',
  'medusa',
  'ojito',
  'piedrita',
  'slime',
  'zombie'
}

local ATTACK = {
  bolitas = 'low_thud',
  esqueletis = 'hitsound_1',
  fantasmita = 'hitsound_2',
  gordito = 'power_hit',
  medusa = 'electrocuted2',
  ojito = 'swing2',
  piedrita = 'low_thud',
  slime = 'eat',
  zombie = 'eat'
}

local DEATH = {
}

function Game_Monster.prototype:constructor(props)
  Game_Event.prototype.constructor(self)
  self.power = props.attack or 40
  self.viewRadius = props['view.radius'] or 5
  self._speed = props.speed or 3
  self._cooldown = 0
  self._dead = false
  self._chase = props['chase'] or false
  local name = props.sprite or self:_randomSprite()
  self._characterName = name
  self._attackSFX = props['sounds.attack'] or ATTACK[name] or "cut"
  self._deadSFX = props['sounds.dead'] or  DEATH[name] or "death_sound1"
  self._movementType = props['move.type'] or 'stay'
  self._movementTime = 0
  self._movementSpeed = props['move.speed'] or 0.3
  self._movementDirection = props['move.direction'] or 'clockwise'
end

function Game_Monster.prototype:_randomSprite()
  local i = math.rand(1, #SPRITES)
  return SPRITES[i]
end

function Game_Monster.prototype:update(dt)
  if self:isDead() then
    if self._color[4] > 0 then
      self._color[4] = math.max(0, self._color[4] - dt)
    end
    return
  end
  Game_Event.prototype.update(self, dt)
  if self._cooldown > 0 then
    self._cooldown = self._cooldown - dt
  end  
  if Game_Player:isDead() or Game_Player:isMoving() or self._cooldown > 0 then
    return
  end
  self:_updateAttack()
  if self:isMoving() or not self._chase then
    return
  end
  self:_updateChase()
  if not self.follower then
    self:_updateNaturalMovement(dt)
  end
end

function Game_Monster.prototype:_updateNaturalMovement(dt)
  local type = self._movementType
  if self._movementTime > 0 then
    self._movementTime = self._movementTime - dt
    return
  end
  if type == 'random' then
    local dir = Array("up", "left", "down", "right"):pick()
    self:move(dir)
  elseif type == 'rotate' then
    local d = self._direction
    self._movementTime = self._movementSpeed
    if d == 2 then
      if self._movementDirection == 'clockwise' then
        self:face("right")
      else
        self:face("left")
      end
    elseif d == 4 then
      if self._movementDirection == 'clockwise' then
        self:face("up")
      else
        self:face("down")
      end      
    elseif d == 6 then
      if self._movementDirection == 'clockwise' then
        self:face("down")
      else
        self:face("up")
      end      
    elseif d == 8 then
      if self._movementDirection == 'clockwise' then
        self:face("left")
      else
        self:face("right")
      end      
    end
  end
end

function Game_Monster.prototype:_updateAttack()
  local d = 1
  if self.walkable then
    d = 0.5
  end
  if self:distanceFrom(Game_Player._position:get()) <= d then
    if Game_Inventory:hand() == "candle" then
      self:die()
    else
      self:attack()
    end
  end  
end

function Game_Monster.prototype:isDead()
  return self._dead
end

function Game_Monster.prototype:die()
  self._dead = true
  self.walkable = true
  Audio_Manager:playSFX(self._deadSFX)
end

function Game_Monster.prototype:attack()
  Game_Player.hp = math.max(0, Game_Player.hp - self.power)
  self._cooldown = 1
  Audio_Manager:playSFX(self._attackSFX)
  if Game_Player.hp <= 0 then
    Game_Player:die()
  else
    Game_Player:hit(self._direction)
  end
end

function Game_Monster.prototype:_updateChase()
  if self.follower then
    if self:distanceFrom(self.follower._position:get()) > self.viewRadius then
      self.follower = nil
      return
    end
  end
  local follower
  local x1, y1 = self._position:get()
  local x2, y2 = Game_Player._position:get()  
  if self._direction == 2 then
    if x1 == x2 and y2 > y1 then
      follower = Game_Player
    end
  elseif self._direction == 4 then
    if y1 == y2 and x2 < x1 then
      follower = Game_Player
    end
  elseif self._direction == 6 then
    if y1 == y2 and x2 > x1 then
      follower = Game_Player
    end
  elseif self._direction == 8 then
    if x1 == x2 and y2 < y1 then
      follower = Game_Player
    end    
  end
  self.follower = follower
end

Game_Event.templates.monster = Game_Monster
