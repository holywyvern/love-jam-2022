local E = Game_Event:extend("Teleport_Event")

function E.prototype:step()
    Game_Map.interpreter:changeMap(self.map, self.x, self.y, self.direction)
              
end

function E.prototype:constructor(options)
    Game_Event.prototype.constructor(self)
    self.walkable = true
    self.x = options.x
    self.y = options.y
    self.direction = options.direction or Game_Player:direction()
    self.map = options.map
  end

return E