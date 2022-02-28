Game_System = {}

function Game_System:setup()
  self.name = ""
  self.playtime = 0
end

function Game_System:update(dt)
  self.playtime = self.playtime + dt
end

function Game_System:save()
  return { playtime = self.playtime, name = self.name }
end

function Game_System:load(data)
  self.playtime = data.playtime
  self.name = data.name
end
