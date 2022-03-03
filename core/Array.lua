local prototype = setmetatable({}, { __index = Object.prototype, __metatable = false })
Array = { name = "Array", class = Class, prototype = prototype }

local function arrayGet(self, key)
  if type(key) == 'number' then
    return self._data[key]
  end
  if key == 'length' then
    return #(self._data)
  end
  return Array.prototype[key]
end

local function arraySet(self, key, value)
  if type(key) == 'number' then
    self._data[key] = value
    return value
  end
  if key == 'length' then
    return
  end
  local set = table.rawset or rawset
  set(self, key, value)
  return value
end

local function newArray(class, ...)
  local instance = { class = class }
  instance._data = { ... }
  setmetatable(instance, { __index = arrayGet, __newindex = arraySet, __metatable = false })
  instance:constructor(...)
  return instance
end

setmetatable(Array, { __index = Class.prototype, __metatable = false, __call = newArray })

function Array.prototype:constructor()
end

function Array.prototype:isPresent()
  return self.length > 0
end

function Array.prototype:toString()
  local result = '['
  for k, v in ipairs(self._data) do
    if type(v) then
      result = result .. v:toString()
    else
      result = result .. 'nil'
    end
    if k < #self._data then
      result = result .. ', '
    end
  end
  return result .. ']'
end

function Array.prototype:map(callback)
  local unpk = table.unpack or unpack
  local new = {}
  for k, v in ipairs(self._data) do
    new[k] = callback(v, k, self)
  end
  return Array(unpk(new))
end

function Array.prototype:reduce(callback, first)
  local result = first
  for k, v in ipairs(self._data) do
    result = callback(result, v, k, self)
  end
  return result
end

function Array.prototype:iterator()
  local array = self
  local i = 0
  local length = self.length
  return function()
    i = i + 1
    return array._data[i]
  end
end

function Array.prototype:push(...)
  local data = { ... }
  for _, v in ipairs(data) do
    self._data[#(self._data) + 1] = v
  end
  return self
end

function Array.prototype:pop()
  return table.remove(self._data)
end

function Array.prototype:shift()
  return table.remove(self._data, 1)
end

function Array.prototype:remove(index)
  return table.remove(self._data, index)
end

function Array.prototype:insert(index, ...)
  local values = { ... }
  for i, v in ipairs(values) do
    table.insert(self._data, index + i - 1, v)
  end
  return self
end

function Array.prototype:unshift(...)
  local values = { ... }
  for _, v in ipairs(self._data) do
    values[#values + 1] = v
  end
  self._data = values
  return self
end

function Array.prototype:includes(value)
  for _, v in ipairs(self._data) do
    if v == value then
      return true
    end
  end
  return false
end

function Array.prototype:indexOf(value)
  for k, v in ipairs(self._data) do
    if v == value then
      return k
    end
  end
  return nil
end

function Array.prototype:lastIndexOf(value)
  local i = #(self._data)
  while i > 0 do
    if (value == self._data[i]) then
      return i
    end
    i = i - 1
  end
  return nil
end

function Array.prototype:sort(sorting)
  table.sort(self._data, sorting)
end

function Array.prototype:pick()
  local i = math.rand(1, #(self._data))
  return self._data[i]
end

Array.prototype.class = Array
