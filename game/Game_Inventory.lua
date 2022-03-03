Game_Inventory = {}

Game_Inventory.menuOpen = false
Game_Inventory.selection = 1

Game_Inventory.ITEM_LIST = { "nothing", "candle" }

function Game_Inventory:hand()
  local item = Game_Inventory.ITEM_LIST[self.selection]
  if self:amountOf(item) < 1 then
    return "nothing"
  end
  return item
end

function Game_Inventory:setup()
  self._items = {}
end

function Game_Inventory:save()
  return { items = self._items, selection = self.selection }
end

function Game_Inventory:load(data)
  self._items = data.items or {}
  self.selection = 1
end

function Game_Inventory:amountOf(item)
  if item == "nothing" then
    return 1
  end
  return self._items[item] or 0
end

function Game_Inventory:hasItem(item)
  return self:amountOf(item) > 0
end

function Game_Inventory:consume(item, quantity)
  local amount = math.max(0, self:amountOf(item) - (quantity or 1))
  self._items[item] = amount
end

function Game_Inventory:add(item, amount)
  local amount = self:amountOf(item) + amount
  self._items[item] = math.min(99, math.max(0, amount))
end
