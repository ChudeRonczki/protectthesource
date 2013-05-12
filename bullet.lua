Class = require "lib/class"
vector = require "lib/vector-light"
anim8 = require "lib/anim8"
tween = require "lib/tween"

local Bullet = Class{}
local qbullet

function Bullet:init(angle)
  self.gangle = angle
  self.dx,self.dy = vector.rotate(angle,1,0)
  self.x,self.y = 400 + self.dx*98, 300 + self.dy*98
  self.dx,self.dy = self.dx*100,self.dy*100
  if not tbullet then
    qbullet = love.graphics.newQuad(0,400,70,30,1024,1024)
  end
  self.todelete = false
  self.alpha = {v = 0}
  self.left = (550-98)*0.01
  tween(1,self.alpha,{v=255},"outQuad")
end

function Bullet:update(dt)
  self.x,self.y,self.left = self.x+self.dx*dt,self.y+self.dy*dt,self.left-dt
end

function Bullet:draw(v)
  if v == 255 then batch:setColor(255,255,255,self.alpha.v)
  else batch:setColor(255,255,255,v) end
  batch:addq(qbullet,self.x,self.y,self.gangle,1,1,65,15)
  batch:setColor(255,255,255,255)
end

return Bullet