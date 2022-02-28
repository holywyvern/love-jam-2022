local Save_Event = Game_Event:extend("Save_Event")

function Save_Event.prototype:trigger()
  Scene_Manager:push(Scene_Save())
end

return Save_Event
