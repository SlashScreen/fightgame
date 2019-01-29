--camera.lua

camera = {}

local utils = require "modules/utils"

function camera:calculate(players)
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
    piter = piter+1
  end
  for i =1 ,#xl do
    dist[i] = utils:pythag(xl[i]-xl[i-1],yl[i]-yl[i-1]) --find distance
    centerx = centerx + dxl[i] --add to midpoints
    centery = centery + dyl[i]
  end

  camwide = utils:maxtable(dist)+margin --calc length and margin
  zoom = basecam/camwide --calc zoom
  centerx = (centerx/#dxl)/zoom --average points. TODO: this is the point in world coords I should center on, bot not screen coords
  centery = (centery/#dyl)/zoom

  return zoom,centerx,centery
end

return camera
