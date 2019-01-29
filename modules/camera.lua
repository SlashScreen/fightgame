--camera.lua

camera = {}

local utils = require "modules/utils"

function camera:calculate(players)
  xl = {}
  yl = {}
  dist = {}
  dist[1] = 0
  camwide = 0
  basecam = 500
  margin = 200
  centerx , centery = 0,0
  --print(centerx,centery)
  --print("-------------pos")
  piter = 0
  for g,p in pairs(players) do --get positions of all players
    xl[piter],yl[piter] = p.phys.body:getPosition()
    --print(g,"--g")
    piter = piter+1
  end
  --utils:printTable(xl)
  for i =1 ,#xl do
    dist[i] = utils:pythag(xl[i]-xl[i-1],yl[i]-yl[i-1]) --find distance
    --print(centerx,centery)
    centerx = centerx + xl[i] --add to midpoints
    centery = centery + yl[i]
    --print(centerx,centery)
  end

  --utils:printTable(pos)
  --print(centerx,centery)
  camwide = utils:maxtable(dist)+margin --calc length and margin
  centerx = centerx/#xl --average points
  centery = centery/#yl
  --print(centerx,centery)
  --print("-------------end")
  zoom = basecam/camwide --calc zoom
  --print(centerx,centery)
  return zoom,centerx,centery
end

return camera
