local E = Game_Event:extend("Home::TV_Event")

function E.prototype:trigger()
  Game_Map.interpreter:message(
    "I can't turn the [color=3]TV[/color] on since\nthere's no power.",
    { showFrame = true, position = "bottom" }
  )
  Game_Map.interpreter:message(
    "I really miss watching TV!",
    { showFrame = true, position = "bottom" }
  )

end

return E