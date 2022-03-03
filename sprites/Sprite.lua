Sprite = Object:extend("Sprite")

function Sprite.prototype:constructor(image)
  self.image = image or nil
  self.srcRect = Rect(0, 0, 1, 1)
  self.position = Point()
  self.scale = Point(1, 1)
  self.offset = Point()
  self.shearing = Point()
  self.quad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)
  self.angle = 0
end

function Sprite.prototype:update(dt)
  if not self.image then
    return
  end
  local src = self.srcRect
  self.quad:setViewport(src.x, src.y, src.width, src.height, self.image:getDimensions())
end

function Sprite.prototype:draw()
  if not self.image then
    return
  end
  local x, y = self.position:get()
  local sx, sy = self.scale:get()
  local ox, oy = self.offset:get()
  local kx, ky = self.shearing:get()
  if self.color then
    local unpk = unpack or table.unpack
    love.graphics.setColor(unpk(self.color))
  else
    love.graphics.setColor(1, 1, 1, 1)
  end
  -- love.graphics.draw(self.image, self.quad, x, y)
  love.graphics.draw(self.image, self.quad, x, y, self.angle, sx, sy, ox, oy, kx, ky)
end
