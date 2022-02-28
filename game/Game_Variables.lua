Game_Variables = {}

function Game_Variables:setup()
  self._values = {}
end

function Game_Variables:get(name)
  return self._values[name] or 0
end

function Game_Variables:set(name, value)
  self._values[name] = value or 0
  return value
end

function Game_Variables:save()
  return self._values
end

function Game_Variables:load(data)
  self._values = data or {}
end

