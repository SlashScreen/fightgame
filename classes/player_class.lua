--player.lua

player = {}

local fos = require "fightOS"
local utils = require "modules/utils"

function player:calcAttack(attack,boxes,adata,players)
  print("--a--")
  --utils:printTable(boxes[attack])
  --utils:printTable(players)
  --print(adata[attack]["type"])
  type = adata[attack]["type"]
  damage = 0
  target = nil
  for _,p in pairs(players) do
    for g,a in pairs(boxes[attack]) do
       --print(g,a["x"])
      -- utils:printTable(a)
       x1,y1,x2,y2 = p.phys.shape:computeAABB(0,0,0,0)
       w1 = x2-x1
       h1 = y2-y1
       if utils:CheckCollision(self.x+a["x"],self.y+a["y"],a["w"],a["h"],x1,y1,w1,h1) then
         print(type)
         if type == "one" then
           damage = adata[attack]["damage"]
           target = p
           return damage
         else
           damage = damage + adata[attack]["damage"]
           target = p --maybe do multiple targets at once?
         end
       end
    end
  end
  return damage, target
end

function player:reFix() --make a new fixture, used for sliding
  if self.phys.fixture then
    self.phys.fixture:destroy()
  end
  self.phys.fixture = love.physics.newFixture(self.phys.body, self.phys.shape, 5) -- A higher density gives it more mass.
end

function player:init(world,char)

  --[[
  TODO:
  -sprites
  -attacks
  -damage/knockback
  -test hitboxes
  -control based on availible inputs?
  ]]
  self.fdata, self.adata, self.aboxes = fos:loadchar(char)
  print("self boxes")
  utils:printTable(self.aboxes)
  self.x,self.y = 0,0
  self.opponents = nil
  self.standshape = love.physics.newRectangleShape(0, 0, 50, 100)
  self.slideshape = love.physics.newRectangleShape(0, 0, 50, 40)
  self.jumpcounter = 1
  self.jumpmax = fdata["jump"]
  self.speed = fdata["speed"]
  self.health = fdata["health"]
  self.isAgile = fdata["agile"]
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

--[[UPDATE]]--

function player:update(dt,players)

  self.opponents = players

  self.x,self.y = self.phys.body:getPosition()

  if #self.phys.body:getContacts() == 0 then --better control in air; in air or on land
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
    --is this necessary?
  end

  if love.keyboard.isDown("lshift") then --SLIDE SHAPE
    self.state = "slide"
    self.phys.shape = self.slideshape
    self:reFix()
    self.phys.fixture:setFriction(.1)
  end
  function love.keyreleased(key)
    if key == "lshift" then
      self.state = "land"
      self.phys.shape = self.standshape
      self.phys.fixture:setFriction(.5)
      self:reFix()
    end
  end
  if self.state ~= "slide" then
    if love.keyboard.isDown("d") then --press the d key to push the player to the right
      self.dir = 1
      self.phys.body:applyForce(10000*self.speed, 0)
    elseif love.keyboard.isDown("a") then --press a key to push the player to the left
      self.dir = -1
      self.phys.body:applyForce(-10000*self.speed, 0)
    end
  end
  xv,yv = self.phys.body:getLinearVelocity()
  function love.keypressed(key)
     if key == "escape" then --quit
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
     if key == "e" then
       self:calcAttack("primary", self.aboxes,self.adata,self.opponents)
     end
  end
end

function player:draw()
  love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the player
  love.graphics.polygon("fill", self.phys.body:getWorldPoints(self.phys.shape:getPoints()))
end

return player
