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
  aboxes = {}
  w = 16
  group = utils:create(hclass)
  group:init()
  for g,m in pairs(adata) do
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
    aboxes[g]=boxes --boxes for attack name g
  end
  return group
end

function fos:loadchar(char)
  fconfig = io.open("fighters/"..char.."/fconfig.json","r") --fighter config file
  aconfig = io.open("fighters/"..char.."//attacks/aconfig.json","r") --fighter attack config file
  fdata = json.decode(fconfig:read("*all")) --fighter config table
  adata = json.decode(aconfig:read("*all")) --attack config table
  --TODO: make objects out of adata
  agroup = fos:parseHitbox(adata)
  return fdata,adata,agroup
end

return fos
