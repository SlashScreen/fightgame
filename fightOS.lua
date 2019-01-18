--fightOS.lua

fos = {}
local json = require "modules/vendor/json"

function fos:loadchar(char)
  fconfig = io.open("fighters/"..char.."/fconfig.json","r") --fighter config file
  aconfig = io.open("fighters/"..char.."//attacks/aconfig.json","r") --fighter attack config file
  fdata = json.decode(fconfig:read("*all")) --fighter config table
  adata = json.decode(aconfig:read("*all")) --attack config table
  --TODO: make objects out of adata
  print(fdata["x"])
  return fdata,adata
end

return fos
