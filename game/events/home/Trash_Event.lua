local E = Game_Event:extend("Home::Trash_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "Smells so bad...",
    { showFrame = true, position = "bottom" }
  )
end

return E