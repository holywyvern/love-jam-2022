local Save_Event = Game_Event:extend("Save_Event")

function Save_Event.prototype:setupProps()
  self._characterName = 'save_point'
  self._standAnim = true
  self.__animDelay = 0.3
  self.light = {
    radius = 16,
    red = 1,
    green = 1,
    blue = 1,
    alpha = 0.5,
    offset = Point(8, 8)
  }
end

function Save_Event.prototype:trigger()
  if not Game_Switches:get("game.save") then
    Game_Map.interpreter:message(
      "I can save my game here.",
      { showFrame = true, position = "bottom" }
    )
    Game_Map.interpreter:switchOn("game.save")
  end
  Game_Map.interpreter:heal()
  Game_Map.interpreter:save()
end

return Save_Event
