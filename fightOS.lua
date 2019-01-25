--fightOS.lua

fos = {}
local json = require "modules/vendor/json"
local utils = require "modules/utils"
local hitbox = require "classes/hitbox_class"
local hclass = require "classes/hitbox_group_class"

function fos:parseHitbox(adata)
  x = 0
  y = 0
  boxes = {}
  agroups = {}
  w = 16
  for g,m in pairs(adata) do
    group = utils:create(hclass)
    group:init()
    for t,h in pairs(m["hit"]["frames"]) do
      x = 0
      y = 0
      boxes = {}
      for i = 1, #h do
        local c = h:sub(i,i)
        if c == "/" then
          x = 0
          y = y-1
        else
          --print(x,y)
          group:add(x,y)
          x = x+1
        end
      end
    end
    agroups[g]=utils:deepcopy(group) --boxes for attack name g
  end
  return agroups
end

function fos:loadchar(char)
  fconfig,_ = love.filesystem.read("fighters/"..char.."/fconfig.json") --fighter config file
  aconfig,_ = love.filesystem.read("fighters/"..char.."//attacks/aconfig.json") --fighter attack config file
  fdata = json.decode(fconfig) --fighter config table
  adata = json.decode(aconfig) --attack config table
  --TODO: make objects out of adata
  agroup = fos:parseHitbox(adata)
  return fdata,adata,agroup
end

return fos
