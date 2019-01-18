--main.lua
function love.load()
  local fos = require "fightOS"
  local game = require "game"
  p = game:load()
  fos:loadchar("test")
  -- body...
end

function love.update(dt)
  game:update(dt,p)
  -- body...
end

function love.draw()
  game:draw(p)
  -- body...
end
