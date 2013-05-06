local anim8 = require "lib/anim8"
local gamestate = require "lib/gamestate"
local tween = require "lib/tween"

local gameplay = {}

local t1
local rm,rmg
local r1,r1g,r1r
local r2,r2g,r2r
local center
local alpha = {v = 0}
local playing = false
local points = 0
local pstring = "points\n0"
local nextDrop = 0
local nextDropTime = 5
local Drop = require "drop"
local nextBug = 0.5
local nextBugTime = 2.5
local Bug = require "bug"
local bugs = {}
local drops = {}
local energy = 9
local mx,my,rmr
local bTime = 0
local bullets = {}
local Bullet = require "bullet"

function gameplay:enter()
  alpha = {v = 0}
  playing = false
  points = 0
  pstring = "points\n0"
  nextDrop = 0
  nextDropTime = 5
  drops = {}
  nextBug = 0.5
  nextBugTime = 2.5
  bugs = {}
  energy = 9
  bTime = 0
  bullets = {}
  tween(3,alpha,{v = 255},"outQuad", function() playing = true end)
end

function gameplay:load()
  t1 = love.graphics.newImage("gfx/t1.png")
  local g = anim8.newGrid(200,200,t1:getWidth(),t1:getHeight())
  local quads = g('1-5',1,'1-2',2)
  rmg,rm,r1g,r1,r2g,r2,center = unpack(quads)
  r1r = 0
  r2r = twopi
end

function gameplay:keypressed(key)
  if key == "escape" then
    drop:stop()
    drop:play()
    gamestate.switch(require "menu")
  end
end

function gameplay:mousepressed(x,y,key)
  if key == "l" and bTime <= 0 and playing then
    table.insert(bullets,Bullet(rmr))
    bTime = 0.5
  end
end

function gameplay:update(dt)
  mx, my = love.mouse.getX(), love.mouse.getY()
  rmr = math.atan2(my-300,mx-400)
  if playing then
    if bTime > 0 then bTime = bTime - dt end
    local i = 1
    while i <= #bullets do
      bullets[i]:update(dt)
      local hitb = false
      for j = 1,#bugs do
        if (bullets[i].x - bugs[j].x)^2 + (bullets[i].y - bugs[j].y)^2 < 550 then
            bugs[j].golden = true
            points = points + 10
            pstring = "points\n"..points
            hit:stop()
            hit:play()
            bugs[j]:fade()
            hitb = true
            break
        end
      end
      if hitb or bullets[i].left <= 0 then
        table.remove(bullets,i)
      else i = i + 1 end
    end
    for i = 1,#drops do
      if not drops[i].fading then
        drops[i]:update(dt)
        if drops[i].left <= 0 then
          local limit = math.pi*0.084
          local leftr,rightr = rmr+limit,rmr-limit
          local caught = false
          if leftr > math.pi then 
            leftr = leftr - twopi
            if drops[i].angle > rightr or drops[i].angle < leftr then caught = true end  
          end
          if rightr <= -math.pi then
            rightr = rightr + twopi
            if drops[i].angle > rightr or drops[i].angle < leftr then caught = true end
          elseif drops[i].angle > rightr and drops[i].angle < leftr then caught = true end
          if caught then
            drops[i].golden = true
            points = points + 10
            pstring = "points\n"..points
            drop:stop()
            drop:play()
          else
            energy = energy - 1
            if energy == 0 then
              tween(2,alpha,{v=0},"inQuad", function() gamestate.switch(require "final",points) end)
              playing = false
              return
            end
            lost:stop()
            lost:play()
          end
          drops[i]:fade()
        end
      end
    end
    if #drops > 0 and drops[1].todelete then table.remove(drops,1) end 
    nextDrop = nextDrop - dt
    if nextDrop <= 0 then
      table.insert(drops,Drop())
      nextDrop = nextDrop + nextDropTime
      nextDropTime = nextDropTime - 0.05
      if nextDropTime < 0.1 then nextDropTime = 0.1 end
    end
    for i = 1,#bugs do
      if not bugs[i].fading then
        bugs[i]:update(dt)
        if bugs[i].left <= 0 then
          energy = energy - 1
            if energy == 0 then
              tween(2,alpha,{v=0},"inQuad", function() gamestate.switch(require "final",points) end)
              playing = false
              return
            end
          bugs[i]:fade()
          lost:stop()
          lost:play()
        end
      end
    end    
    if #bugs > 0 and bugs[1].todelete then table.remove(bugs,1) end 
    nextBug = nextBug - dt
    if nextBug <= 0 then
      table.insert(bugs,Bug())
      nextBug = nextBug + nextBugTime
      nextBugTime = nextBugTime - 0.025
      if nextBugTime < 0.1 then nextBugTime = 0.1 end
    end
  end
  r1r = r1r + dt*0.1
  if r1r >= twopi then r1r = r1r - twopi end
  r2r = r2r - dt*0.2
  if r2r < 0 then r2r = twopi + r2r end
end

function gameplay:draw()
  love.graphics.setColor(255,255,255,alpha.v)
  love.graphics.drawq(t1,center,300,200)
  if playing then
    if energy > 2 then love.graphics.setColor(255,255,255,255)
    else love.graphics.setColor(255,255,255,255*energy/3) end
    love.graphics.drawq(t1,r2g,400,300,r2r,1,1,100,100)
    love.graphics.setColor(255,255,255,alpha.v)
  elseif energy > 0 then love.graphics.drawq(t1,r2g,400,300,r2r,1,1,100,100) end
  love.graphics.drawq(t1,r2,400,300,r2r,1,1,100,100)
  if playing then
    if energy > 5 then love.graphics.setColor(255,255,255,255)
    elseif energy < 4 then love.graphics.setColor(255,255,255,0)
    else love.graphics.setColor(255,255,255,255*(energy-3)/3) end
    love.graphics.drawq(t1,r1g,400,300,r1r,1,1,100,100)
    love.graphics.setColor(255,255,255,alpha.v)
  elseif energy > 0 then love.graphics.drawq(t1,r1g,400,300,r1r,1,1,100,100) end
  love.graphics.drawq(t1,r1,400,300,r1r,1,1,100,100)
  if playing then
    if energy < 7 then love.graphics.setColor(255,255,255,0)
    else love.graphics.setColor(255,255,255,255*(energy-6)/3) end
    love.graphics.drawq(t1,rmg,400,300,rmr,1,1,100,100)
    love.graphics.setColor(255,255,255,alpha.v)
  elseif energy > 0 then love.graphics.drawq(t1,rmg,400,300,rmr,1,1,100,100) end
  love.graphics.drawq(t1,rm,400,300,rmr,1,1,100,100)
  love.graphics.setColor(30,20,0,alpha.v)
  love.graphics.setFont(fonts)
  love.graphics.printf(pstring,350,288,100,"center")
  love.graphics.setColor(255,255,255,255)
  for i = 1,#bugs do
    bugs[i]:draw(alpha.v)
  end
  for i = 1,#bullets do
    bullets[i]:draw(alpha.v)
  end
  for i = 1,#drops do
    drops[i]:draw(alpha.v)
  end
  love.graphics.draw(cross,mx,my,0,1,1,30,30)
end

return gameplay;