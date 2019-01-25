--camera.lua

camera = {}

local utils = require "modules/utils"

function camera:calculate(players)
  pos = {}
  dist = {}
  dist[1] = 0
  camwide = 0
  basecam = 500
  margin = 200
  centerx , centery = 0,0
  for g,p in pairs(players) do --get positions of all players
    pos[g] = {}
    pos[g]["x"],pos[g]["y"] = p.phys.body:getPosition()
  end
  for i =2 ,#pos do
    dist[i] = utils:pythag(pos[i]["x"]-pos[i-1]["x"],pos[i]["y"]-pos[i-1]["y"]) --find distance
    centerx = centerx + pos[i].x --add to midpoints
    centery = centery + pos[i].y
  end
  camwide = utils:maxtable(dist)+margin --calc length and margin
  centerx = centerx/#pos --average points
  centery = centery/#pos
  zoom = camwide/basecam --calc zoom
  --print(zoom)
  return zoom,centerx,centery
end

return camera
