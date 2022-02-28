local E = Game_Event:extend("Home::Bed_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "No time for resting!\nI need to find my boyfriend.",
    { showFrame = true, position = "bottom" }
  )
end

return E