Sprite_TitleCommand = Sprite:extend("Sprite_TitleCommand")

function Sprite_TitleCommand.prototype:constructor(index, image, command)
  Sprite.prototype.constructor(self, image)
  local w, h = image:getDimensions()
  self.index = index
  self.command = command
  self.position:set((Game_Camera.width - w) / 2,  Game_Camera.height - h * (4 - index))
  self.srcRect:set(0, 0, w, h)
end
