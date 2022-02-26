Game_Switches = {}

function Game_Switches:setup()
  self._values = {}
end

function Game_Switches:get(name)
  return self._values or 0
end

function Game_Switches:set(name, value)
  self._values[name] = value or 0
  return value
end
