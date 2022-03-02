local function copyTable(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

local function toString(self)
  return self:toString()
end

local function newInstance(class, ...)
  local newMeta = { __metatable = false, __index = class.prototype, __tostring = toString }
  function newMeta:__call(...)
    return self:call(...)
  end
  local instance = setmetatable({ class = class }, newMeta)
  instance:constructor(...)
  return instance
end

local function newClass(class, name, parent)
  parent = parent or Object
  local prototype = setmetatable({}, { __index = parent.prototype })
  local instance = { name = name, class = class, prototype = prototype }
  setmetatable(instance, { __index = class.prototype, __call = newInstance, __metatable = false, __tostring = toString })
  instance:constructor(name, parent)
  return instance
end

Class = {
  name = "Class",
  prototype = setmetatable({}, { __index = Object.prototype })
}
Class.class = Class

function Class.prototype:constructor(name, parent)
  parent = parent or Object
  self.name = name
  self.parent = parent
  self.prototype = setmetatable({}, { __index = parent.prototype, __metatable = false })
end

function Class.prototype:toString()
  local name = self.name or '???'
  return 'Class<' .. name .. '>'
end

Class.prototype.extend = Object.extend

setmetatable(Class, { 
  __index = Object.prototype,
  __call = newClass,
  __metatable = false,
  __tostring = toString
})

Object.class = Class
setmetatable(Object, {
  __index = Class.prototype,
  __call = newInstance,
  __metatable = false,
  __tostring = toString
})
