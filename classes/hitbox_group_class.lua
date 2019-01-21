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
 hit:init(x,y,self.w,self.w)
 --print(hit["x"],hit["y"])
 self.boxes[#self.boxes+1] = utils:deepcopy(hit);
 hit = nil

end

function group:collide(op,dir,players,d)
 --loop
  damage = 0
  target = nil
  ox1,oy1,ox2,oy2 = op.phys.body:getWorldPoints(op.phys.shape:getPoints())
  --utils:printTable(players)
  for n,p in pairs(players) do
    if p ~= op then
      x1,y1,x2,y2 = p.phys.body:getWorldPoints(p.phys.shape:getPoints())
      w1 = x2-x1
      h1 = y2-y1
      for _,a in pairs(self.boxes) do
        if dir == 1 then
          hit = utils:CheckCollision(ox2+a["x"]*self.w,oy1-a["y"]*self.w,a["w"],a["h"],x1,y1,w1,100)
        else
          hit = utils:CheckCollision(ox1-((a["x"]+1)*self.w),oy1-a["y"]*self.w,a["w"],a["h"],x1,y1,w1,100)
        end

        if hit then
          --print(x1,y1,x2,y2)
          --print(x1,y1,w1,h1)
          if type == "one" then
            damage = d
            target = p
            target:damage(damage,dir)
            return
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

function group:draw(op,dir)
 --loop draw from x y
 love.graphics.setColor(0.55, 0.55, 0.55) --set the drawing color to grey for the box
 ox1,oy1,ox2,oy2 = op.phys.body:getWorldPoints(op.phys.shape:getPoints())
 for j,a in pairs(self.boxes) do
   --print(j,a["x"],a["y"])
   if dir == 1 then
     love.graphics.rectangle( "line", ox2+a["x"]*self.w, oy1-a["y"]*self.w, a["w"], a["h"] )
   else
     love.graphics.rectangle( "line", ox1-((a["x"]+1)*self.w), oy1-a["y"]*self.w, a["w"], a["h"] )
   end
 end
end

return group
