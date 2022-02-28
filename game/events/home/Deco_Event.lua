local E = Game_Event:extend("Home::Deco_EventArt_")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "Some art my boyfriend made.",
    { showFrame = true, position = "bottom" }
  )
end

return E