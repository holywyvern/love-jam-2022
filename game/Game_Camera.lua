Game_Camera = {}

local SCREEN_WIDTH = 32 * 16
local SCREEN_HEIGHT = 32 * 9

function Game_Camera:setup()
  self._cam = StalkerX.new(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT)
  self._cam:setFollowStyle('TOPDOWN_TIGHT')
  self._brady = Brady(SCREEN_WIDTH, SCREEN_HEIGHT, { maintainAspectRatio = true, resizable = true, center = true })
end
function Game_Camera:update(dt)
  self._cam:update(dt)
  if self.follower then
    self._cam:follow(self.follower.x, self.follower.y)
  end
  self._brady:update()
end

function Game_Camera:push()
  self._cam:attach()
end

function Game_Camera:pop()
  self._cam:detach()
  self._cam:draw()  
end

function Game_Camera:beginRender()
  self._brady:push()
end

function Game_Camera:endRender()
  self._brady:pop()
end

Game_Camera.width = SCREEN_WIDTH
Game_Camera.height = SCREEN_HEIGHT