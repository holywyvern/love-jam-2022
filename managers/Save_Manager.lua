Save_Manager = {}

Save_Manager.MAX_FILES = 4
Save_Manager._selectedIndex = 1

function Save_Manager:setup()
  self._selectedIndex = 1
end

function Save_Manager:save(index)
  local file = self:_filenameFor(index)
  self._selectedIndex = index
  local data = { header = {}, contents = {} }
  self:_makeHeader(data.header, index)
  self:_saveContents(data.contents)
  local json = JSON.encode(data)
  return love.filesystem.write(file, json)
end

function Save_Manager:load(index)
  local file = self:_filenameFor(index)
  self._selectedIndex = index
  local data = love.filesystem.read(file)
  local json = JSON.decode(data or "{}")
  self:_loadContents(json.contents or {})
end

function Save_Manager:autosave()
  self:save(self._selectedIndex)
end

function Save_Manager:getFiles()
  local files = Array()
  for i=1,Save_Manager.MAX_FILES do
    local info = love.filesystem.getInfo(self:_filenameFor(i), "file")
    if info then
      files:push(self:_loadHeader(i))
    else
      files:push(false)
    end
  end
  return files
end

function Save_Manager:hasSaves()
  for i=1,Save_Manager.MAX_FILES do
    local info = love.filesystem.getInfo(self:_filenameFor(i), "file")
    if info then
      return true
    end
  end
  return false
end

function Save_Manager:exists(i)
  local info = love.filesystem.getInfo(self:_filenameFor(i), "file")
  if info then
    return true
  end
  return false
end

function Save_Manager:_filenameFor(index)
  return 'SAVE' .. tostring(index) .. '.lvdata'
end

function Save_Manager:_loadHeader(index)
  local file = self:_filenameFor(index)
  local data = love.filesystem.read(file)
  local json = JSON.decode(data or "{}")
  if not json then
    return {}
  end
  return json.header or {}
end

function Save_Manager:_makeHeader(header, index)
  local secs = math.floor(Game_System.playtime)
  local s = tostring(secs % 60)
  local m = tostring(math.floor(secs / 60) % 60)
  local h = tostring(math.floor(secs / (60 * 60)))
  if #s < 2 then
    s = "0" .. s
  end
  if #m < 2 then
    m = "0" .. m
  end
  if #h < 2 then
    h = "0" .. h
  end
  local stamp = h .. ':' .. m .. ':' .. s
  header.timestamp = stamp
  header.name = "File " .. tostring(index)
end

function Save_Manager:_saveContents(data)
  data.map = Game_Map:save()
  data.player = Game_Player:save()
  data.switches = Game_Switches:save()
  data.variables = Game_Variables:save()
  data.inventory = Game_Inventory:save()
  data.system = Game_System:save()
end

function Save_Manager:_loadContents(data)
  Game_Map:load(data.map)
  Game_Player:load(data.player)
  Game_Switches:load(data.switches)
  Game_Variables:load(data.variables)
  Game_Inventory:load(data.inventory)
  Game_System:load(data.system)
end
