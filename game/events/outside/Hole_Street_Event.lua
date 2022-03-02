local E = Game_Event:extend("Outside::Hole_Street_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "There\'s literally a hole on the \nstreet... That\'s insane!",
    { showFrame = true, position = "bottom" }
  )


end

return E