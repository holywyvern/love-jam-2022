local E = Game_Event:extend("Home::Fridge_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "All the food has spoiled since the\nblackout... what a waste.",
    { showFrame = true, position = "bottom" }
  )
end

return E