local E = Game_Event:extend("Home::Art_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "My boyfriend is an artist.\n" ..
    "Hope he is alright...",
    { showFrame = true, position = "bottom" }
  )
end

return E