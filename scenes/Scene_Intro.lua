Scene_Intro = Scene_Base:extend("Scene_Intro")

function Scene_Intro.prototype:constructor()
  Scene_Base.prototype.constructor(self)
  self._interpreter = Game_Interpreter()
  self._interpreter:message(
    "An earthquake has struck our\n" ..
    "town today.",
    { position = "center" }
  )
  self._interpreter:message(
    "Everything shattered,\n" ..
    "everything went dark..."
  )
  self._interpreter:message(
    "There's no energy or way of\n" ..
    "communication..."
  )
  self._interpreter:message(
    "My boyfriend hasn’t come\n" ..
    "back from work yet."
  )
  self._interpreter:message(
    "He should be here already.\n" ..
    "Where is he? Is he alright?"
  )
  self._interpreter:message(
    "I've got to go and find him..."
  )
  self._interpreter:enter(Scene_Map())
end

function Scene_Intro.prototype:update(dt)
  Scene_Base.prototype.update(self, dt)
  self._interpreter:update(dt)
end
