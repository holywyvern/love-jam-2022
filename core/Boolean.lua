Boolean = Object:extend("Boolean")

function Boolean.prototype:isPresent()
  return self
end

function Boolean.prototype:toString()
  if self then
    return 'true'
  end
  return 'false'
end

Boolean.prototype.class = Boolean

local meta = { __index = Boolean.prototype, __metatable = false, __tostring = function (self) return self:toString() end }
debug.setmetatable(false, meta)
debug.setmetatable(true, meta)
