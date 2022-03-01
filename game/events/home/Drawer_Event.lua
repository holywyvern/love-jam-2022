local E = Game_Event:extend("Home::Drawer_Event")

function E.prototype:trigger()
  if Game_Switches:get("home.candles") then
    Game_Map.interpreter:message(
      "There is nothing else here.",
      { showFrame = true, position = "bottom" }
    )
  else
    Game_Map.interpreter:message(
      "Here, there are some candles!",
      { showFrame = true, position = "bottom" }
    )
    Game_Map.interpreter:message(
      "Obtained [color=2]3 candles[/color]!",
      { showFrame = true, position = "bottom" }
    )
    Game_Map.interpreter:switchOn("home.candles")
    --Game_Map.interpreter:addItem("candles", 3)
  end
end

return E