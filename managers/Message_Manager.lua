Message_Manager = {}

local BOPS = { 0, -1, 0, 1 }

function Message_Manager:setup()
  Palettes = {
    {0.9, 0.9, 0.9, 1},
    {0.9, 0, 0, 1},
    {0, 0.9, 0, 1},
    {0, 0, 0.9, 1},
    {0.9, 0.9, 0, 1},
    {0.9, 0, 0.9, 1},
    {0, 0.9, 0.9, 1},
    {0.5, 0.5, 1, 0.4}
  } 
  images = { frame = {} }
  images.frame.default_8 = Assets.graphics.system.frame
  Slog.frame.load()
  Icon.configure(16, Assets.graphics.system.iconset)
  Slog.text.configure.icon_table("Icon")
  Slog.text.configure.audio_table("Audio")
  Slog.text.configure.palette_table("Palettes")
  Slog.text.configure.add_text_sound(Audio.text.default, 0.2) 
  Slog.text.configure.add_text_sound(Audio.text.typing, 0.2) 
  Slog.text.configure.add_text_sound(Audio.text.cackle, 0.2) 
  Slog.text.configure.add_text_sound(Audio.text.neue, 0.2)
  self._text = Slog.text.new("left", {
    color = {0.9,0.9,0.9,1},
    shadow_color = {0.5,0.5,1,0.4}, 
    font = Assets.fonts.silver(Game_Camera.tileSize),
    character_sound = true, 
    sound_every = 2, 
    sound_number = 1,
    adjust_line_height = -2,
  })
  self._wait = 0
  self._cursorBop = 0
  self._bop = 1
  self._visible = false
  self._lastPosition = 'bottom'
  self._options = { showFrame = false, position = 'bottom' }
end

function Message_Manager:update(dt)
  self._text:update(dt)
  self._cursorBop = self._cursorBop + 4 * dt
  if self._wait > 0 then
    self._wait = self._wait - dt
  end
  if self._cursorBop > 1 then
    self._cursorBop = self._cursorBop - 1
    self._bop = self._bop + 1
    if self._bop > 4 then
      self._bop = 1
    end
  end
  if self._visible and not self._text:is_end() then
    if Player:pressed('cancel') then
      self._text:skip()
    end
  elseif self._visible and self._text:is_finished() then
    if Player:pressed('accept') then
      if self._text:is_end() then
        self._visible = false
        self._wait = 0.3
        Audio_Manager:playSFX("menu_select")
      elseif self._text:is_paused() then
        self._text:continue()
        Audio_Manager:playSFX("menu_select")
      end
    end
  end
end

function Message_Manager:draw()
  if self._visible then
    local width = Game_Camera.width
    local height = Game_Camera.height
    local boxWidth = Game_Camera.width * 3 / 4
    local x, y = (width - boxWidth) / 2, 8
    local p = Game_Camera.tileSize / 4
    if self._options.position == 'bottom' then
      y = height  - Game_Camera.tileSize * 2 - p * 3
    elseif self._options.position == 'center' then
      y = (height - Game_Camera.tileSize * 2) / 2
    end
    if self._options.showFrame then
      Slog.frame.draw("default", x, y, boxWidth, Game_Camera.tileSize * 2 + p * 2)
    end
    self._text:draw(x + p * 2, y + p)
    if self._text:is_finished() then
      local bop = BOPS[self._bop]
      love.graphics.draw(Assets.graphics.system.cursor, (width - 16) / 2, y + Game_Camera.tileSize + p * 4 + 2 + bop)
    end
  end
end

function Message_Manager:blocksInput()
  return self._visible or self._wait > 0
end

function Message_Manager:show(text, options)
  self._visible = true
  self._text:send(text)
  options = options or {}
  self._options.showFrame = options.showFrame or false
  self._options.position = options.position or self._lastPosition
  self._lastPosition = self._options.position
end
