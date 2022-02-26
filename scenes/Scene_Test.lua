Scene_Test = Scene_Base:extend("Scene_Test")

function Scene_Test.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  Message_Manager:update(dt)
end

function Scene_Test.prototype:draw()
  love.graphics.clear()
  Message_Manager:draw()
end

function Scene_Test.prototype:enter(previous)
  Message_Manager:show("Hello this is an example text.\nWith multiple lines!")
end
