Number = Object:extend("Number")

local function numberGet(n, k)
  if k == 'class' then
    return Number
  end
  return Number.prototype[k]
end

debug.setmetatable(1, { __index = numberGet, __metatable = false })

function Number.prototype:toString()
  return tostring(self)
end

Number.prototype.class = Number
