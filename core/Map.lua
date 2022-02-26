local prototype = setmetatable({}, { __index = Object.prototype, __metatable = false })
Map = { name = "Map", class = Class, prototype = prototype }

local function mapLength(map)
  local i = 0
  for k, v in pairs(map._data) do
    i = i + 1
  end
  return i
end

local function mapGet(self, key)
  if key == 'size' then
    return mapLength(self)
  end
  if Map.prototype[key] then
    return Map.prototype[key]
  end
  local get = table.rawget or rawget
  return get(self._data, key)
end

local function mapSet(self, key, value)
  if key == 'size' then
    return
  end
  local set = table.rawset or rawset
  set(self._data, key, value)
  return value
end

local function newMap(class, ...)
  local instance = { class = class }
  instance._data = {}
  setmetatable(instance, { __index = mapGet, __newindex = mapSet, __metatable = false })
  instance:constructor(...)
  return instance
end

setmetatable(Map, { __index = Class.prototype, __metatable = false, __call = newMap, __tostring = function (self) return self:toString() end })

function Map.prototype:constructor()
end

function Map.prototype:toString()
  local result = '{ '
  for k, v in pairs(self._data) do
    result = result .. k:toString() .. ' = ' .. v:toString() .. ", "
  end
  return result .. ' }'
end

function Map.prototype:get(key)
  local get = table.rawget or rawget
  return get(self._data, key)
end

function Map.prototype:set(key, value)
  local set = table.rawset or rawset
  set(self._data, key, value)
  return value
end

function Map.prototype:keys()
  local result = {}
  for k, _ in pairs(self._data) do
    result[#result + 1] = k
  end
  local unpk = table.unpack or unpack
  return Array(unpk(result))
end

function Map.prototype:values()
  local result = {}
  for _, v in pairs(self._data) do
    result[#result + 1] = v
  end
  local unpk = table.unpack or unpack
  return Array(unpk(result))  
end

function Map.prototype:pairs()
  local result = {}
  for k, v in pairs(self._data) do
    result[#result + 1] = Array(k, v)
  end
  local unpk = table.unpack or unpack
  return Array(unpk(result))  
end

function Map.prototype:includes(value)
  for k, v in pairs(self._data) do
    if k == value or v == value then
      return true
    end
  end
  return false
end

function Map.prototype:has(key)
  if type(self._data[key]) then
    return true
  end
  return false
end

Map.prototype.class = Map
