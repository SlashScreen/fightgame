--utils.lua
utils = {}

function utils:create (o)
  o = o or {}   -- create object if user does not provide one
      setmetatable(o, self)
      o.__index = self
      return o
end

function utils:printTable(table,depth)
  if depth == nil then
    depth = 0
  end
  for key,value in pairs(table) do
    if type(value) == "table" then
      print(string.rep("   ",depth)..key)
      utils:printTable(value,depth+1)
    else
      print(string.rep("   ",depth)..key,value)
    end
  end
end

return utils
