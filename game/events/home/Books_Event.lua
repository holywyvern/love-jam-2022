local E = Game_Event:extend("Home::Books_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "I wish to read a lot,\nafter this ends...",
    { showFrame = true, position = "bottom" }
  )
end

return E