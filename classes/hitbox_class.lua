--hitbox_class.lua

hitbox = {}

local utils = require "modules/utils"

function hitbox:init(x,y,w,h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
end

return hitbox
