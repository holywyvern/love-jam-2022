Game_Inventory = {}

function Game_Inventory:setup()
  self._items = {}
end

function Game_Inventory:save()
  return self._items
end

function Game_Inventory:load(data)
  self._items = data or {}
end

function Game_Inventory:amountOf(item)
  return self._items[item] or 0
end

function Game_Inventory:hasItem(item)
  return self:amountOf(item) > 0
end

function Game_Inventory:consume(item)
  local amount = math.max(0, self:amountOf(item) - 1)
  self._items[item] = amount
end
