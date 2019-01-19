--fightOS.lua

fos = {}
local json = require "modules/vendor/json"
local utils = require "modules/utils"

function fos:parseHitbox(adata)
    for g,m in pairs(adata) do
      --utils:printTable(i)
      for t,h in pairs(m["hit"]["frames"]) do
        print(h)
        for i = 1, #h do
          local c = h:sub(i,i)
          print(c)
          end
      end
    end
end

function fos:loadchar(char)
  fconfig = io.open("fighters/"..char.."/fconfig.json","r") --fighter config file
  aconfig = io.open("fighters/"..char.."//attacks/aconfig.json","r") --fighter attack config file
  fdata = json.decode(fconfig:read("*all")) --fighter config table
  adata = json.decode(aconfig:read("*all")) --attack config table
  --TODO: make objects out of adata
  print(fdata["health"])
  fos:parseHitbox(adata)
  return fdata,adata
end

return fos
