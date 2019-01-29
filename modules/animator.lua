--animator.lua
--Animator is an object attatched to anything that needs animation, that will handle all timing and  drawing
--for that object.

ani = {} --initialize "ani" ("animator" that's easy to type for someone who is bad at typing) table for functions
local utils = require "modules/utils"

function ani:init(anims)
  --This will initialize the animator object with the animations availible to the object it's animating for.

  self.aset = anims --animation set
  self.fps = 1 --default fps
  self.job = "" --the name of the animation to play
  self.timer = 0 --internal timer
  self.frame = 0 --internal frame count
end

function ani:update(dt)
  --update timer based on fps
  if self.job == "" then
    print("I need something to animate - call newJob")
  end
  self.timer = self.timer + dt --increment timer by time

  if self.timer >= self.fps then --increment frame if mathches fps value and resets timer
    self.frame = self.frame+1
    self.timer = 0
  end
  if self.frame > #self.aset-1 then --reset frame if reached max
    self.frame = 0
  end
end

function ani:newJob(name,fps)
  --tell what animation to play and what fps
  self.job = job
  self.fps = fps
  self.timer = 0
  self.frame = 0
end

function ani:draw(x,y,zoom,cx,cy)
  --Calls draw function for current frame
  utils:draw(self.aset["src"][self.job],self.aset[self.job][self.frame],x,y,cx,cy,zoom)
end

return ani --returns table: very important in lua, otherwise module won't work
