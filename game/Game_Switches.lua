Game_Switches = {}

function Game_Switches:setup()
  self._values = {}
end

function Game_Switches:get(name)
  return self._values[name] or false
end

function Game_Switches:set(name, value)
  self._values[name] = value or false
  return value
end

function Game_Switches:save()
  return self._values
end

function Game_Switches:load(data)
  self._values = data or {}
end

