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
    print(type(value))
    if type(value) == "table" then
      print(string.rep("   ",depth)..key)
      utils:printTable(value,depth+1)
    else
      print(string.rep("   ",depth)..key,tostring(value))
    end
  end
end

function utils:getQuads(jsonfile,image)
  f = assert(io.open(jsonfile, "r")):read("*all")
  aes_tbl=json.decode (f)
  frames = {}
  i=0
  img = love.graphics.newImage(image)
  for key,frame in pairs(aes_tbl["frames"]) do
    c = frame["frame"]
    i = c["x"]/c["w"] --figure out orger based on width
    frames[i] = love.graphics.newQuad(c["x"],c["y"],c["w"],c["h"],img:getDimensions())
  end
  return frames
end

function utils:CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

return utils
