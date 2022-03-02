local E = Game_Event:extend("Home::TV_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "I can't turn the TV on since\nthere's no power.",
    { showFrame = true, position = "bottom" }
  )


end

return E