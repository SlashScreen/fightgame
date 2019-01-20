--player.lua

player = {}

local fos = require "fightOS"
local utils = require "modules/utils"

function player:damage(d)
  self.health = self.health - d
  print (self.health)
end

function player:calcAttack(attack,boxes,adata,players)
  print("--a--")
  type = adata[attack]["type"]
  damage = 0
  target = nil
  for _,p in pairs(players) do
    for g,a in pairs(boxes[attack]) do
       x1,y1,x2,y2 = p.phys.shape:computeAABB(0,0,0,0)
       w1 = x2-x1
       h1 = y2-y1
       if utils:CheckCollision(self.x+a["x"],self.y+a["y"],a["w"],a["h"],x1,y1,w1,h1) then
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

--[[REFIX]]--

function player:reFix() --make a new fixture, used for sliding
  if self.phys.fixture then
    self.phys.fixture:destroy()
  end
  self.phys.fixture = love.physics.newFixture(self.phys.body, self.phys.shape, 5) -- A higher density gives it more mass.
end

--[[INIT]]--

function player:init(world,char,x,y,name)

  --[[
  TODO:
  -sprites
  -attacks
  -damage/knockback
  -test hitboxes
  -control based on availible inputs?
  ]]
  self.name = name
  self.fdata, self.adata, self.aboxes = fos:loadchar(char)
  print("self boxes")
  self.dummy = dummy
  print(dummy,name)
  self.x,self.y = x,y
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
  self.phys.body = love.physics.newBody(world, self.x, self.y, "dynamic") --make body  at x y
  self.phys.body:setFixedRotation(true)
  self.phys.shape = self.standshape
  self:reFix()
  self.phys.fixture:setFriction(.5)
end

--[[UPDATE]]--

function player:update(dt,players)

  --print(self.name)

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
end

function player:draw()
  love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the player
  love.graphics.polygon("fill", self.phys.body:getWorldPoints(self.phys.shape:getPoints()))
end

return player
