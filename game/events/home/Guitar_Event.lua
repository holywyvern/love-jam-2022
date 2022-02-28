local E = Game_Event:extend("Home::Guitar_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "I can't play the guitar!\nThere is no electricity!",
    { showFrame = true, position = "bottom" }
  )
end

return E