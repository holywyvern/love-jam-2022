local E = Game_Event:extend("Home::Exit_Event")

function E.prototype:constructor()
  Game_Event.prototype.constructor(self)
  self.walkable = true
end

function E.prototype:step()
  if Game_Switches:get("home.candles") then
    Game_Map.interpreter:message(
      "",
      { showFrame = true, position = "bottom" }
    )
  else
    Game_Map.interpreter:message(
      "It's really dark outside. I\n" ..
      "need [color=2]some light[/color] before I go!",
      { showFrame = true, position = "bottom" }
    )
    Game_Map.interpreter:message(
      "I sure have [color=2]some candles[/color]\n" ..
      "in the [color=2]drawer[/color].",
      { showFrame = true, position = "bottom" }
    )
    Game_Map.interpreter:move(Game_Player, "up", true)
  end
end

return E