local Save_Event = Game_Event:extend("Save_Event")

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
