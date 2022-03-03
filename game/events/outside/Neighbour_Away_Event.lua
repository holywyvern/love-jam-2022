local E = Game_Event:extend("Outside::Neighbour_Away_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "My neighbour's house is\n pretty fucked up...",
    { showFrame = true, position = "bottom" }
  )
  Game_Map.interpreter:message(
    "I can\'t hear anything so I guess\n no one\'s home.",
    { showFrame = true, position = "bottom" }
  )

end
return E