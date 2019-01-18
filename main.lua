--main.lua
function love.load()
  local fos = require "fightOS"
  local game = require "game"
  game:load()
  fos:loadchar("test")
  -- body...
end

function love.update(dt)
  game:update(dt)
  -- body...
end

function love.draw()
  game:draw()
  -- body...
end
