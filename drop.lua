Class = require "lib/class"
vector = require "lib/vector-light"
anim8 = require "lib/anim8"
tween = require "lib/tween"

local Drop = Class{}
local dropb,dropg,tdrop

function Drop:init()
  self.angle = math.random()*twopi-math.pi
  self.gangle = self.angle + math.pi*0.5
  self.dx,self.dy = vector.rotate(self.angle,-1,0)
  self.x,self.y = 400 - self.dx*550, 300 - self.dy*550
  self.dx,self.dy = self.dx*50,self.dy*50
  if not dropb then
    tdrop = love.graphics.newImage("gfx/kropla.png")
    local g = anim8.newGrid(50,50,tdrop:getWidth(),tdrop:getHeight())
    local quads = g('1-2',1)
    dropb,dropg = unpack(quads)
  end
  self.fading = false
  self.todelete = false
  self.golden = false
  self.alpha = {v = 255}
  self.left = (550-98)*0.02
end

function Drop:update(dt)
  if not fading then self.x,self.y,self.left = self.x+self.dx*dt,self.y+self.dy*dt,self.left-dt end
end

function Drop:fade()
  self.fading = true
  tween(1,self.alpha,{v=0},"inQuad",function() self.todelete = true end)
end

function Drop:draw(v)
  if v == 255 then love.graphics.setColor(255,255,255,self.alpha.v)
  else love.graphics.setColor(255,255,255,v) end
  if not self.golden then love.graphics.drawq(tdrop,dropb,self.x,self.y,self.gangle,1,1,25,25)
  else love.graphics.drawq(tdrop,dropg,self.x,self.y,self.gangle,1,1,25,25) end
  love.graphics.setColor(255,255,255,255)
end

return Drop