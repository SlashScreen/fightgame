--utils.lua
utils = {}
local json = require "modules/vendor/json"

function utils:lerp(a,b,t) return a+(b-a)*t end

function utils:draw(img,q,x,y,cx,cy,scale)
  --print(img,q)
  width, height = love.graphics.getDimensions()
  w = width/2
  h = height/2
  print(w,h)
  --+utils:lerp(0,cy-(cy+y),scale)
  print(w+utils:lerp(0,cx-(cx-x),scale),h+utils:lerp(0,cy-(cy-y),scale))
  love.graphics.draw(img,q,w+utils:lerp(0,cx-(cx-x),scale),utils:lerp(0,cy-(cy-y),scale),0,scale,scale) --train of thought: anchored on center of screen
end

function utils:create (o)
  o = o or {}   -- create object if user does not provide one
      setmetatable(o, self)
      o.__index = self
      return o
end

function utils:deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[utils:deepcopy(orig_key)] = utils:deepcopy(orig_value)
        end
        setmetatable(copy, utils:deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function utils:maxtable (tbl)
  highest = 0
  for i,v in pairs(tbl)do
	    if v > highest then
	        highest = v
	    end
	end
  return highest
end

function utils:pythag(a,b)
  return math.sqrt((a*a)+(b*b))
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
  f = assert(love.filesystem.read(jsonfile))
  aes_tbl=json.decode (f)
  frames = {}
  i=0
  img = love.graphics.newImage(image)
  for key,frame in pairs(aes_tbl["frames"]) do
    c = frame["frame"]
    i = c["x"]/c["w"] --figure out order based on width
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
