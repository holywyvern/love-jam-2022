local Save_Event = Game_Event:extend("Save_Event")

function Save_Event.prototype:trigger()
  Game_Player:heal()
  Scene_Manager:push(Scene_Save())
end

return Save_Event
