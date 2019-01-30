--camera.lua

camera = {}

local utils = require "modules/utils"

function camera:calculate(players)
  width, height = love.graphics.getDimensions()
  xl = {}
  yl = {}
  dxl = {}
  dyl = {}
  dist = {}
  dist[1] = 0
  camwide = 0
  basecam = 500
  margin = 200
  centerx , centery = 0,0
  piter = 0
  for g,p in pairs(players) do --get positions of all players
    xl[piter],yl[piter] = p.phys.body:getPosition()
    dxl[piter],dyl[piter] = p.phys.body:getWorldPoints(p.phys.shape:getPoints())
    --print(dyl[piter])
    piter = piter+1
  end
  for i =1 ,#xl do
    dist[i] = utils:pythag(xl[i]-xl[i-1],yl[i]-yl[i-1]) --find distance
  end

  for _,j in pairs(dxl) do
    centerx = centerx+j
  end
  for _,j in pairs(dyl) do
    centery = centery+j
  end

  camwide = utils:maxtable(dist)+margin --calc length and margin
  zoom = basecam/camwide --calc zoom
  centerx = (centerx/#players) --average points.
  centery = (centery/#players)
  
  --figure out how to make it so that it draws x based on zoom? /zoom
  return zoom,centerx,centery
end

return camera
