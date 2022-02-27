Rect = Object:extend("Rect")

function Rect.prototype:constructor(x, y, width, height)
  self.x = x or 0
  self.y = y or 0
  self.width = width or 1
  self.height = height or 1
end

function Rect.prototype:set(x, y, w, h)
  self.x = x or self.x
  self.y = y or self.y
  self.width = w or self.width
  self.height = h or self.height
end
