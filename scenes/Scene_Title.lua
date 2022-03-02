Scene_Title = Scene_Base:extend("Scene_Title")

local STARTING_MAP = "mapa_home_lua"
local STARTING_POSITION = { 11, 8 }

function Scene_Title.prototype:enter()
  self._setupNewGame()
  self._selected = 1
  self._commands = Array()
  if Save_Manager:hasSaves() then
    self._commands:push(Sprite_TitleCommand(self._commands.length - 1, Assets.graphics.title.continue, self.commandContinue:bind(self)))
  end
  self._commands:push(Sprite_TitleCommand(self._commands.length - 1, Assets.graphics.title.new, self.commandNewGame:bind(self)))
  self._commands:push(Sprite_TitleCommand(self._commands.length - 1, Assets.graphics.title.exit, self.commandExit:bind(self)))
  self._cursor = Assets.graphics.title.cursor
  self._back = Assets.graphics.title.back
  self._title = Assets.graphics.title.title
  self._opacity = 0
end

function Scene_Title.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  for command in self._commands:iterator() do
    command:update(dt)
  end  
  if self._opacity < 1 then
    self._opacity = math.min(1, self._opacity + dt)
    return
  end
  if Player:pressed("down") then
    self._selected = self._selected + 1
    if self._selected > self._commands.length then
      self._selected = 1
    end
    Audio_Manager:playSFX("menu_select2") 
  elseif Player:pressed("up") then
    self._selected = self._selected - 1
    if self._selected < 1 then
      self._selected = self._commands.length
    end
    Audio_Manager:playSFX("menu_select2") 
  elseif Player:pressed("accept") then
    self:_onSelect()
    Audio_Manager:playSFX("menu_select")
  elseif Player:pressed("cancel") then
    self._selected = self._commands.length
    Audio_Manager:playSFX("menu_back") 
  end
end

function Scene_Title.prototype:drawUI()
  love.graphics.setColor(1, 1, 1, self._opacity)
  love.graphics.draw(self._back)
  local tw, th = self._title:getDimensions()
  local tx = (Game_Camera.width - tw) / 2
  local ty = 8
  love.graphics.draw(self._title, tx, ty)
  for command in self._commands:iterator() do
    command:draw()
  end
  local selected = self._commands[self._selected]
  love.graphics.draw(self._cursor, selected.position.x - 10, selected.position.y + 5)
  love.graphics.setColor(1, 1, 1, 1)
end

function Scene_Title.prototype:_onSelect()
  local selected = self._commands[self._selected]
  selected.command()
end

function Scene_Title.prototype:commandNewGame()
  self:_setupNewGame()
  Scene_Manager:enter(Scene_Intro())
end

function Scene_Title.prototype:commandContinue()
  Scene_Manager:push(Scene_Load())
end

function Scene_Title.prototype:commandExit()
  love.event.quit()
end

function Scene_Title.prototype._setupNewGame()
  Save_Manager:setup()
  Game_System:setup()
  Game_Switches:setup()
  Game_Variables:setup()
  Game_Camera:setup()
  Game_Map:setup(STARTING_MAP)
  Game_Player:setup(STARTING_POSITION[1], STARTING_POSITION[2])
  Game_Inventory:setup()
end
