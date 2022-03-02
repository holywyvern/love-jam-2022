Spriteset_Inventory = Object:extend()

function Spriteset_Inventory.prototype:constructor()
  self._font = Assets.fonts.silver(16)
  self._quantity = Assets.fonts.silver(16)
end

function Spriteset_Inventory.prototype:update(dt)
end

function Spriteset_Inventory.prototype:draw()
  if not Game_Inventory.menuOpen then
    return
  end
  local w = 24 * 6 + 8 * 2
  local h = 16 + 24 * 2 + 8 * 2
  local x = (Game_Camera.width - w) / 2
  local y = (Game_Camera.height - h) / 2
  Slog.frame.draw("default", x, y, w, h)
  love.graphics.setFont(self._font)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Items", x + 8, y + 8)
  for i, item in ipairs(Game_Inventory.ITEM_LIST) do
    self:_drawItem(x + 8, y + 16 + 8, i, item, Game_Inventory:amountOf(item))
  end
  self:_drawSelection(x + 8, y + 16 + 8)
end

function Spriteset_Inventory.prototype:_drawItem(sx, sy, i, item, amount)
  local x, y, w, h = self:_itemRect(i)
  x = x + sx
  y = y + sy
  if amount < 1 then
    return   
  end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(Assets.graphics.icons[item], x + 4, y + 4)
  if amount > 1 then
    local text = tostring(amount)
    local tw = self._quantity:getWidth(text)
    love.graphics.setFont(self._quantity)
    love.graphics.setColor(1, 0, 1, 1)
    love.graphics.print(text, x + w - tw - 1, y + h - 16)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, x + w - tw, y + h - 17)
  end
end

function Spriteset_Inventory.prototype:_drawSelection(sx, sy)
  local x, y, w, h = self:_itemRect(Game_Inventory.currentSelection)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", x + sx, y + sy, w, h, 4)
end

function Spriteset_Inventory.prototype:_itemRect(i)
  local x = ((i - 1) % 6) * 24
  local y = math.floor((i - 1) / 6) * 24
  return x, y, 24, 24
end
