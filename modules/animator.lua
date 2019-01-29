--animator.lua
--Animator is an object attatched to anything that needs animation, that will handle all timing and  drawing
--for that object.

ani = {}

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
    --TODO: frame count overlap
  end

end

function ani:newJob(name,fps)
  --tell what animation to play and what fps
  self.job = job
  self.fps = fps
end

function ani:draw()
  --Calls draw function for current frame
  --TODO: draw call
end

return ani
