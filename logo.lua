local anim8 = require "lib/anim8"
local tween = require "lib/tween"

local logo = {}

local tlogo
local lglow,ltube
local alphas = {g = 0, t = 0}
local hidden
local tid, vid

function logo:load()
  tlogo = love.graphics.newImage("gfx/logo.png")
  local g = anim8.newGrid(280,110,tlogo:getWidth(),tlogo:getHeight())
  local quads = g(1,'1-2')
  lglow, ltube = unpack(quads)
  hidden = true
end

function logo:show()
  if hidden then
    hidden = false
    vid = tween(3,alphas,{g = 255, t = 255},"outQuad",logo.glowDown,self)
  end
end

function logo:glowDown()
  tid = tween(2, alphas,{g = 50, t = 50},"inQuad",logo.glowUp,self)
end

function logo:glowUp()
  tid = tween(2, alphas,{g = 255, t = 255},"outQuad",logo.glowDown,self)
end

function logo:hide()
  if not hidden then
    tween.stop(tid)
    tween.stop(vid)
    hidden = true
    tween(2,alphas,{g = 0, t = 0},"inQuad")
  end
end

function logo:draw()
  love.graphics.setColor(255,255,255,alphas.g)
  love.graphics.drawq(tlogo,lglow,260,100)
  love.graphics.setColor(255,255,255,alphas.t)
  love.graphics.drawq(tlogo,ltube,260,100)
  love.graphics.setColor(255,255,255,255)
end

return logo