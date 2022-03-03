local E = Game_Event:extend("Home::Exit_Event")

function E.prototype:constructor()
  Game_Event.prototype.constructor(self)
  self.walkable = true
end

function E.prototype:step()
  if Game_Switches:get("home.candles") then
    if Game_Inventory:hand() ~= "candle" then
      if Game_Inventory:amountOf("candle") < 1 then
        Game_Inventory:add("candle", 3)
      end
      Game_Inventory.selection = 2
    end
    Game_Player:setCandleLight()
    Game_Map.interpreter:changeMap("mapa_outside_1_lua", 10, 11, "down")
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