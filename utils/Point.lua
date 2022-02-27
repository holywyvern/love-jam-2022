Point = Object:extend("Point")

function Point.prototype:constructor(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Point.prototype:set(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function Point.prototype:copy(point)
  self.x = point.x
  self.y = point.y
end

function Point.prototype:get()
  return self.x, self.y
end
