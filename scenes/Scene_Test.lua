Scene_Test = Scene_Base:extend("Scene_Test")

function Scene_Test.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  Message_Manager:update(dt)
end

function Scene_Test.prototype:drawObjects()
  Message_Manager:draw()
end

function Scene_Test.prototype:enter(previous)
  Message_Manager:show("[b]H[/b]ello this is an [rainbow=2]example[/rainbow] text.\n[color=1]A[/color][color=2]B[/color][color=3]C[/color][color=4]D[/color][color=5]D[/color][color=6]E[/color][color=7]F[/color][color=8]G[/color]", { showFrame = true, bottom = true })
end
