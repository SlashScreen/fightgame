--main.lua
function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  local fos = require "fightOS"
  local game = require "game"
  p = game:load()
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
