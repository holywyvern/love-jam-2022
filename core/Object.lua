Object = {
  name = "Object",
  prototype = {}
}

function Object:new(...)
  return self(...)
end

function Object:extend(name)
  return Class(name, self)
end

function Object.prototype:constructor()
end

function Object.prototype:is(class)
  local test = self.class
  if class == Object then
    return true
  end
  while test and test ~= Object do
    if test == class then
      return true
    end
    test = test.parent
  end
  return false
end

function Object.prototype:isPresent()
  return true
end

function Object.prototype:inspect()
  return self:toString()
end

function Object.prototype:toString()
  return  "(" .. self.class.name .. ")"
end

