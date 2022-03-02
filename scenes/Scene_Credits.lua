Scene_Credits = Scene_Base:extend("Scene_Credits")

function Scene_Credits.prototype:constructor()
  Scene_Base.prototype.constructor(self)
  self._credits = Array(
    { "Graphics" },
    "Kaidan",
    "Ichan",
    "",
    { "Story" },
    "Ichan",
    "Kaidan",
    "",
    {"Map Design"},
    "Kaidan",
    "Ichan",
    "",
    { "Programming" },
    "Rex",
    "Kaidan",
    "",
    { "Library Programming" },
    "Andrew Minnich",
    "Davis Claiborne",
    "Bjorn Swenson",
    "rxi",
    "Jesse Viikari",
    "Wesley Werner",
    "",    
    {"Sound Effects"},
    "OmegaPixelArt",
    "",
    { "Music" },
    "Casitodoslosmales",
    "",
    { "Special Thanks" },
    "Dungeons & Drags",
    "Violencia",
    "",
    "",
    "",
    "",
    "",
    "",
    "And You!",
    "",
    "Thanks for playing!"
  )
  self._colors = {}
  self._texts = {}
  self._sizes = {}
  self._widths = {}
  self._fonts = {
    [16] = Assets.fonts.silver(16),
    [24] = Assets.fonts.silver(24),
    [32] = Assets.fonts.silver(32)
  }
  self._oy = 0
  local h = 0
  for i=1,self._credits.length do
    h = h + self:_lineHeight(i)
  end
  self._title = Assets.graphics.title.title
  local tw, th = self._title:getDimensions()
  self._height = h + Game_Camera.height / 2 + th
end

function Scene_Credits.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  if self._countdown then
    self._time = self._time - dt
    if self._time <= 0 then
      Scene_Manager:pop()
    end
    return
  end
  local speed = 16
  if Player:down("cancel") then
    speed = 96
  end
  self._oy = self._oy + dt * speed
  if self._oy > self._height then
    self._time = 3
    self._countdown = true
  end
end

function Scene_Credits.prototype:drawUI()
  local w, h = self._title:getDimensions()
  local y = Game_Camera.height - self._oy
  love.graphics.draw(self._title, (Game_Camera.width - w) / 2, y)
  y = y + h + 16
  for i=1,self._credits.length do
    local h = self:_lineHeight(i)
    if y >= -h then
      self:_drawLine(i, y)
    end
    y = y + h
    if y > Game_Camera.height then
      return
    end    
  end  
end

function Scene_Credits.prototype:_drawLine(i, y)
  local line = self._credits[i]
  love.graphics.setColor(self:_lineColor(i))
  local font = self._fonts[self:_lineHeight(i)]
  local text = self:_lineText(i)
  self._widths[i] = self._widths[i] or font:getWidth(text)
  local w = self._widths[i]
  love.graphics.setFont(font)
  love.graphics.print(text, (Game_Camera.width - w) / 2, y)
end

function Scene_Credits.prototype:_lineColor(i)
  local line = self._credits[i]
  local unpk = unpack or table.unpack
  if self._colors[i] then
    return unpk(self._colors[i])
  end
  if type(line) == "string" then
    self._colors[i] = { 0.8, 0.8, 0.8, 1 }
  elseif type(line) == "table" and type(line[1]) == "string" then
    self._colors[i] = {1, 1, 0, 1}
  else
    self._colors[i] = {1, 0, 0, 1}
  end
  return unpk(self._colors[i])
end

function Scene_Credits.prototype:_lineHeight(i)
  if self._sizes[i] then
    return self._sizes[i]
  end
  local line = self._credits[i]
  if type(line) == "string" then
    self._sizes[i] = 16
  elseif type(line) == "table" and type(line[1]) == "string" then
    self._sizes[i] = 16
  else
    self._sizes[i] = 32
  end
  return self._sizes[i]
end

function Scene_Credits.prototype:_lineText(i)
  if self._texts[i] then
    return self._texts[i]
  end
  local line = self._credits[i]
  if type(line) == "string" then
    self._texts[i] = line
  elseif type(line) == "table" and type(line[1]) == "string" then
    self._texts[i] = line[1]
  else
    self._texts[i] = line[1][1]
  end
  return self._texts[i]
end
