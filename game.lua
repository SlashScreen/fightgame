game = {}

function game:load()

  local pclass = require "classes/player_class"
  local utils = require "modules/utils"

  --TODO: Make ground based on map, make rects based on players

  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 20*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
  love.window.setMode(650, 650) --set the window dimensions to 650 by 650

  --[[OBJECTS]]--

  player = utils:create(player)
  player:init(world)

  objects = {} -- table to hold all our physical objects
  --stage
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
  objects.ground.fixture:setFriction(1)
  --[[DEFAULTS]]--


  return player
end

function game:update(dt,player)
  world:update(dt) --this puts the world into motion
  player:update(dt)
 --here we are going to create some keyboard events


end

function game:draw(player)
  love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  player:draw()
end

return game
