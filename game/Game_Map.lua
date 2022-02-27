Game_Map = {}

function Game_Map:setup(mapName)
  self._data = Cartographer.load("assets/data/maps/" .. mapName .. ".lua")
end

function Game_Map:data()
  return self._data;
end

function Game_Map:update(dt)
  Game_Interpreter:update(dt)
  if Game_Interpreter:isRunning() then
    return
  end
  Game_Player:update(dt)
end
