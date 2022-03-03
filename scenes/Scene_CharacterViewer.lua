Scene_CharacterViewer = Scene_Base:extend("Scene_CharacterViewer")

local Sprite_CharacterTest = Sprite_Character:extend("Sprite_CharacterTest")

function Sprite_CharacterTest.prototype:constructor(chara)
  Sprite_Character.prototype.constructor(self, chara)
  self._dirTime = 3
end

function Sprite_CharacterTest.prototype:update(dt)
  Sprite_Character.prototype.update(self, dt)
  if not self.character then
    return
  end
  self.character:update(dt)
  self._dirTime = self._dirTime - dt
  while self._dirTime <= 0 do
    self._dirTime = self._dirTime + 1
    self.character._direction = self.character._direction + 2
    if self.character._direction > 8 then
      self.character._direction = 2
    end
  end
end

local function basename(str)
	return string.gsub(str, "(%w+)%.(%w+)", "%1")
end

function Scene_CharacterViewer.prototype:constructor()
  Scene_Base.prototype.constructor(self)
  self:_loadCharacters()
end

function Scene_CharacterViewer.prototype:_loadCharacters()
  local unpk = table.unpack or unpack
  local files = love.filesystem.getDirectoryItems("assets/graphics/characters") or {}
  self._files = Array(unpk(files)):map(basename)
  self._characters = self._files:map(
    function (name, i)
      local x = (i - 1) % 16 + 1
      local y = math.floor((i - 1) / 16) * 2 + 2
      print(name, x, y)
      local char = Game_Event:from(x, y, {
        sprite = name,
        standAnimation = true
      })
      return char
    end
  )
  self._sprites = self._characters:map(Sprite_CharacterTest)
end

function Scene_CharacterViewer.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  for c in self._sprites:iterator() do
    c:update(dt)
  end
  if Player:pressed("cancel") then
    Scene_Manager:pop()
  end
end

function Scene_CharacterViewer.prototype:drawUI()
  for c in self._sprites:iterator() do
    c:draw()
  end
end
