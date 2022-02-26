Game_Map = {}

function Game_Map:setup(mapName)
end

function Game_Map:update(dt)
  Game_Interpreter:update(dt)
  if Game_Interpreter:isRunning() then
    return
  end
  Game_Player:update(dt)
end
