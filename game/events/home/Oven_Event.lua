local E = Game_Event:extend("Home::Oven_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "I can't cook anything right\nnow.",
    { showFrame = true, position = "bottom" }
  )
end

return E