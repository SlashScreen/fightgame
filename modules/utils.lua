--utils.lua
utils = {}

function utils:create (o)
  o = o or {}   -- create object if user does not provide one
      setmetatable(o, self)
      o.__index = self
      return o
end

return utils
