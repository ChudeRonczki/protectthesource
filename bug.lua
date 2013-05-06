Class = require "lib/class"
vector = require "lib/vector-light"
anim8 = require "lib/anim8"
tween = require "lib/tween"

local Bug = Class{}
local tbug, g, quads, gbug

function Bug:init()
  local angle = math.random()*twopi-math.pi
  self.gangle = angle - math.pi*0.5
  self.dx,self.dy = vector.rotate(angle,-1,0)
  self.x,self.y = 400 - self.dx*550, 300 - self.dy*550
  self.dx,self.dy = self.dx*25,self.dy*25
  if not tbug then
    tbug = love.graphics.newImage("gfx/robal.png")
    g = anim8.newGrid(50,50,tbug:getWidth(),tbug:getHeight())
    quads = g(2,2)
    gbug = unpack(quads)
    quads = g('1-2',1, 1,1, 1,2)
  end
  self.anim = anim8.newAnimation(quads, 0.1)
  self.fading = false
  self.todelete = false
  self.golden = false
  self.alpha = {v = 255}
  self.left = (550-98)*0.04
end

function Bug:update(dt)
  if not fading then
    self.x,self.y,self.left = self.x+self.dx*dt,self.y+self.dy*dt,self.left-dt
    self.anim:update(dt)
  end
end

function Bug:fade()
  self.fading = true
  tween(1,self.alpha,{v=0},"inQuad",function() self.todelete = true end)
end

function Bug:draw(v)
  if v == 255 then love.graphics.setColor(255,255,255,self.alpha.v)
  else love.graphics.setColor(255,255,255,v) end
  if not self.golden then self.anim:draw(tbug,self.x,self.y,self.gangle,1,1,25,25)
  else love.graphics.drawq(tbug,gbug,self.x,self.y,self.gangle,1,1,25,25) end
  love.graphics.setColor(255,255,255,255)
end

return Bug