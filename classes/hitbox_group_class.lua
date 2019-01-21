--hitbox_group_class.lua

group = {}

local utils = require "modules/utils"
local hitbox = require "classes/hitbox_class"

function group:init()
  self.boxes = {}
  self.w = 32
end

function group:add(x,y)
 --add box to group
 hit = utils:create(hitbox)
 hit:init(x*self.w,y*self.w,self.w,self.w)
 self.boxes[#self.boxes+1] = hit;

end

function group:collide(ox,oy,ow,oh,op,dir,players,d)
 --loop
  damage = 0
  target = nil
  --utils:printTable(players)
  for n,p in pairs(players) do
    if p ~= op then
      x1,y1,x2,y2 = p.phys.body:getWorldPoints(p.phys.shape:getPoints())
      w1 = x2-x1
      h1 = y2-y1
      for _,a in pairs(self.boxes) do
        if utils:CheckCollision(ox+ow+a["x"],oy-a["y"],a["w"],a["h"],x1,y1,w1,h1) then
          if type == "one" then
            damage = adata[attack]["damage"]
            target = p
            target:damage(damage,dir)
          else
            damage = damage + d
            target = p --maybe do multiple targets at once?
          end
        end
      end
    end
    if target then
      target:damage(damage,dir)
    end
  end
end

function group:draw(x,y,w,h,dir)
 --loop draw from x y
 love.graphics.setColor(0.55, 0.55, 0.55) --set the drawing color to grey for the box

 for j,a in pairs(self.boxes) do
   --print(j)
   love.graphics.rectangle( "line", x+w+a["x"], y-a["y"], a["w"], a["h"] )
 end
end

return group
