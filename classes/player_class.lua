--player.lua

player = {}

function player:reFix()
  self.phys.fixture = love.physics.newFixture(self.phys.body, self.phys.shape, 5) -- A higher density gives it more mass.
end

function player:init(world)

  --[[
  TODO:
  -base off of json file
  -sprites
  -improve air control (conditional linear damping?)
  -attacks
  -jump limit (based on config file)
  -speed (fconfig)
  ]]

  self.standshape = love.physics.newRectangleShape(0, 0, 50, 100)
  self.slideshape = love.physics.newRectangleShape(0, 0, 50, 40)
  self.jumpcounter = 1
  self.jumpmax = 3
  self.state = "land"
  self.dashed = false
  self.dir = 1
  self.phys = {}
  self.phys.body = love.physics.newBody(world, 200, 550, "dynamic")
  self.phys.body:setFixedRotation(true)
  self.phys.shape = self.standshape
  self:reFix()
  self.phys.fixture:setFriction(.5)
end

function player:update(dt)
  if #self.phys.body:getContacts() == 0 then --better control in air
    self.state = "air"
  else
    self.state = "land"
  end

  if self.state == "air" then
    self.phys.body:setLinearDamping(1) --TODO: state: inair, not in air
  elseif self.state == "land" then
    self.jumpcounter = 1
    self.dashed = false
    self.phys.body:setLinearDamping(0)
  elseif self.state == "slide" then

  end

  --[[if love.keyboard.isDown("lshift") then --SLIDE SHAPE
    self.state = "slide"
    --print("slide")
    self.phys.shape = self.slideshape
    self:reFix()
  end
  function love.keyreleased(key)
    if key == "lshift" then
      self.state = "land"
      self.phys.shape = self.standshape
      self:reFix()
    end
  end]]

  --if not self.state == "slide" then
    if love.keyboard.isDown("d") then --press the d key to push the player to the right
      self.dir = 1
      self.phys.body:applyForce(10000, 0)
    elseif love.keyboard.isDown("a") then --press a key to push the player to the left
      self.dir = -1
      self.phys.body:applyForce(-10000, 0)
    end
  --end
  xv,yv = self.phys.body:getLinearVelocity()
  function love.keypressed(key)
     if key == "escape" then
       love.event.quit()
     end
     if key == "space" then --AIR CONTROL
       if self.jumpcounter <= self.jumpmax and self.state ~= "dash" then --Jump
        self.jumpcounter = self.jumpcounter+1
        self.phys.body:setLinearVelocity(xv, -500)
       end
       if self.jumpcounter > self.jumpmax-1 and self.state == "air" and self.dashed == false then --Dash
         self.state = "dash"
         self.phys.body:applyForce(1000000*self.dir, 0)
         self.dashed = true
       end
       if self.state == "dash" and self.dashed == true then --Cancel
         self.phys.body:setLinearVelocity(0, -200)
         self.state = "air"
       end
     end
  end
end

function player:draw()
  love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the player
  love.graphics.polygon("fill", self.phys.body:getWorldPoints(self.phys.shape:getPoints()))
end

return player
