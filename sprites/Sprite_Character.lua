Sprite_Character = Sprite:extend("Sprite_Character")

function Sprite_Character.prototype:constructor(character, lighter)
  Sprite.prototype.constructor(self)
  self.character = character
  self._characterName = nil
  self._lighter = lighter
end

function Sprite_Character.prototype:update(dt)
  Sprite.prototype.update(self, dt)
  if not self.character then
    return
  end
  self.character:update(dt)
  self:updateSprite()
  self:updateRect()
  self:updatePosition()
  self:updateLight(dt)
end

function Sprite_Character.prototype:updateLight()
  if not self.light or not self._lighter then
    return
  end
  local x, y = self.character._realPosition:get()
  local ox, oy = self.character.light.offset:get()
  self._lighter:updateLight(self.light, x + ox, y + oy)
end

function Sprite_Character.prototype:updateSprite()
  if self.character._characterName ~= self._characterName then
    self._characterName = self.character._characterName
    if self._characterName then
      self.image = Assets.graphics.characters[self._characterName]
      local w, h = self.image:getDimensions()
      local x = w / 6
      local y = h / 4
      self.offset:set(x, y)
    else
      self.image = nil
    end
  end
end

function Sprite_Character.prototype:updateRect()
  if not self.image then
    return
  end
  local w, h = self.image:getDimensions()
  local fw = w / 3
  local fh = h / 4
  local frame = self.character:frame()
  local pose = math.floor(self.character:direction() / 2) - 1
  self.srcRect:set(frame * fw, pose * fh, fw, fh)
end

function Sprite_Character.prototype:updatePosition()
  self.position:copy(self.character._realPosition)
end
