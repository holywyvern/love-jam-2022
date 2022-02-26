Message_Manager = {}

local BOPS = { 0, -1, 0, 1 }

function Message_Manager:setup()
  self._text = Slog.text.new("left", {
    color = {1,1,1,1},
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Assets.fonts.silver(32),
    character_sound = true, 
    sound_every = 5, 
    sound_number = 2,
    adjust_line_height = -2,
  })
  self._cursorBop = 0
  self._bop = 1
  self._visible = false
end

function Message_Manager:update(dt)
  self._text:update(dt)
  self._cursorBop = self._cursorBop + 4 * dt
  if self._cursorBop > 1 then
    self._cursorBop = self._cursorBop - 1
    self._bop = self._bop + 1
    if self._bop > 4 then
      self._bop = 1
    end
  end
  if self._visible and self._text:is_finished() then
    if Player:pressed('accept') then
      self._visible = false
    end
  end
end

function Message_Manager:draw()
  if self._visible then
    local width = Game_Camera.width
    local height = Game_Camera.height
    local x, y = (width - 320) / 2, height - 88
    Slog.frame.draw("default", x, y, 320, 80)
    self._text:draw(x + 8, y + 8)
    if self._text:is_finished() then
      local bop = BOPS[self._bop]
      love.graphics.draw(Assets.graphics.system.cursor, (width - 16) / 2, height - 18 + bop)
    end
  end
end

function Message_Manager:blocksInput()
  return self._visible
end

function Message_Manager:show(text)
  self._visible = true
  self._text:send(text)
end
