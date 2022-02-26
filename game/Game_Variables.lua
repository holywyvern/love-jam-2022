Game_Variables = {}

function Game_Variables:setup()
  self._values = {}
end

function Game_Variables:get(name)
  return self._values or 0
end

function Game_Variables:set(name, value)
  self._values[name] = value or 0
  return value
end
