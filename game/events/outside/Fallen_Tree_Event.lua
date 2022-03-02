local E = Game_Event:extend("Outside::Fallen_Tree_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "It must have fallen during the \nearthquake",
    { showFrame = true, position = "bottom" }
  )


end

return E