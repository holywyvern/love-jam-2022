Function = Object:extend("Function")

debug.setmetatable(function () end, {
  __index = Function.prototype,
  __metatable = false,
})

Function.prototype.class = Function

function Function.prototype:bind(...)
  local curry = { ... }
  local old = self
  local unpk = table.unpack or unpack
  return function(...)
    local args = {}
    local new = {...}
    for _, v in ipairs(curry) do
      args[#args + 1] = v
    end
    for _, v in ipairs(new) do
      args[#args + 1] = v
    end
    return old(unpk(args))
  end
end
