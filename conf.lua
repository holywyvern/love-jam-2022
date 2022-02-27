function love.conf(t)
  local TILE_SIZE = 16
  local SCALE = 4
  t.identity = 'love_jav_2022'
  -- For debugging, build must have it as false
  t.console = true
  t.title = "Löve Jam 2022"
  -- Set by default a 16:9 resolution (the most common one)
  t.window.width = TILE_SIZE * 16 * SCALE
  t.window.height = TILE_SIZE * 9 * SCALE
  t.window.resizable = true
end
