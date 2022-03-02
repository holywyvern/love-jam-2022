local E = Game_Event:extend("Outside::Street_Crack_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "This crack on the street is huge.\n I don't wanna fall in there.",
    { showFrame = true, position = "bottom" }
  )


end

return E