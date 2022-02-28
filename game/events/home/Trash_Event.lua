local E = Game_Event:extend("Home::Trash_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "It's full of spoiled food.",
    { showFrame = true, position = "bottom" }
  )
end

return E