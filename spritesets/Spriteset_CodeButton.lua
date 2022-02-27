Spriteset_CodeButton = Object:extend("Spriteset_CodeButton")

function Spriteset_CodeButton.prototype:constructor(i, count, spacing, up, down, digits)
  local w, h = up:getDimensions()
  self.index = i
  self.count = count
  self.up = up
  self.down = down
  self.digits = digits
  self.digit = 0
  local dw, dh = digits:getDimensions()
  self.digitQuad = love.graphics.newQuad(0, 0, dw, dh / 9, dw, dh)
  self.upQuad = love.graphics.newQuad(0, 0, w, h / 2, w, h)
  self.downQuad = love.graphics.newQuad(0, 0, w, h / 2, w, h)
  self.height = h + dh / 10
  self.width = math.max(w, dw)
  self.buttonHeight = h / 2
  self.digitHeight = dh / 10
  self._upTime = 0
  self._downTime = 0
  self.x = (Game_Camera.width - self.width * count - spacing * (count - 1)) / 2 + (i - 1) * (self.width + spacing)
  self.y = 16 * 2
end

function Spriteset_CodeButton.prototype:update(dt)
  if self._upTime > 0 then
    self._upTime = self._upTime - dt
    self.upQuad:setViewport(0, self.buttonHeight, self.width, self.buttonHeight)
  else
    self.upQuad:setViewport(0, 0, self.width, self.buttonHeight)
  end
  if self._downTime > 0 then
    self._downTime = self._downTime - dt
    self.downQuad:setViewport(0, self.buttonHeight, self.width, self.buttonHeight)
  else
    self.downQuad:setViewport(0, 0, self.width, self.buttonHeight)
  end
  self.digitQuad:setViewport(0, self.digitHeight * self.digit, self.width, self.digitHeight)
end

function Spriteset_CodeButton.prototype:draw()
  local y = self.y
  love.graphics.draw(self.up, self.upQuad, self.x, y)
  y = y + self.buttonHeight
  love.graphics.draw(self.digits, self.digitQuad, self.x, y)
  y = y + self.digitHeight
  love.graphics.draw(self.down, self.downQuad, self.x, y)
end
