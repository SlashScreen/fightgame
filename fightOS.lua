--fightOS.lua

fos = {}
local json = require "modules/vendor/json"
local utils = require "modules/utils"
local hitbox = require "classes/hitbox_class"

function fos:parseHitbox(adata)
  x = 0
  y = 0
  boxes = {}
  boxes[x] = {}
  aboxes = {}
    for g,m in pairs(adata) do
      --utils:printTable(i)
      for t,h in pairs(m["hit"]["frames"]) do
        print(h)
        for i = 1, #h do
          local c = h:sub(i,i)
          print(c)
          if c == "/" then
            x = 0
            y = y+1
          else
            hit = utils:create(hitbox)
            boxes[x][y] = hit:init(x*32,y*32,32,32)
          end
        end
      end
      aboxes[g]=boxes --boxes for attack name g
    end
  return aboxes
end

function fos:loadchar(char)
  fconfig = io.open("fighters/"..char.."/fconfig.json","r") --fighter config file
  aconfig = io.open("fighters/"..char.."//attacks/aconfig.json","r") --fighter attack config file
  fdata = json.decode(fconfig:read("*all")) --fighter config table
  adata = json.decode(aconfig:read("*all")) --attack config table
  --TODO: make objects out of adata
  print(fdata["health"])
  abox = fos:parseHitbox(adata)
  utils:printTable(abox)
  return fdata,adata
end

return fos
