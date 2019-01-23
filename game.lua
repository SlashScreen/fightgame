game = {}

function game:load()

  local pclass = require "classes/player_class"
  local dclass = require "classes/dummy_class"
  local utils = require "modules/utils"
  local camera = require "modules/camera"

  --TODO: Make ground based on map, make rects based on players

  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 20*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
  love.window.setMode(650, 650) --set the window dimensions to 650 by 650

  --[[OBJECTS]]--

  --players
  players = {}
  pl = utils:create(pclass) --these both refer to the same object ????
  pl:init(world,"test",100,150,"player")
  players[#players+1] = utils:deepcopy(pl);
  dum = utils:create(dclass)
  dum:init(world,"test",300,150,"dummy")
  players[#players+1] = utils:deepcopy(dum)

  --utils:printTable(pl)

  objects = {} -- table to hold all our physical objects
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
  objects.ground.fixture:setFriction(1)

  --cam

  zoom, cx, cy = camera:calculate(players)
  return players
end

function game:update(dt,players)
  zoom, cx, cy = camera:calculate(players)
  world:update(dt) --this puts the world into motion
  for _,p in pairs(players) do
    --print(p.name)
    p:update(dt,players)
  end

end

function game:draw(players)
  love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  for _,p in pairs(players) do
    p:draw()
  end
end

return game
