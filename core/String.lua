local utf8 = require("utf8")

String = Object:extend("String")

for k, v in pairs(string) do
  String.prototype[k] = v
end

for k, v in pairs(utf8) do
  String.prototype[k] = v
end

local meta = getmetatable("")
meta.__index = String.prototype
meta.__metatable = false

function String.prototype:toString()
  return self
end

String.prototype.class = String
