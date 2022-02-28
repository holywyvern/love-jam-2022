local E = Game_Event:extend("Home::Plant_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "The plants are already watered.",
    { showFrame = true, position = "bottom" }
  )
end

return E