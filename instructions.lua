local gamestate = require "lib/gamestate"
local tween = require "lib/tween"

local instructions = {}

local itemsc = {a = 0}
local tid
local active = 0
local switching = false

function instructions:enter()
  tid = tween(3,itemsc,{a=255},"outQuad")
end

function instructions:leave()
  switching = false
end

function instructions:load()
end

function instructions:keypressed(key)
  if key == "escape" and not switching then 
    switching = true
    tween.stop(tid)
    drop:stop()
    drop:play()
    tween(2,itemsc,{a=0},"inQuad",function() gamestate.switch(require "menu") end)
  end
end

function instructions:mousepressed(x,y,key)
  if key == "l" and not switching and active ~= 0 then
    switching = true
    tween.stop(tid)
    drop:stop()
    drop:play()
    if active == 1 then
      tween(2,itemsc,{a=0},"inQuad",function() gamestate.switch(require "menu") end)
    end
  end
end

function instructions:update(dt)
  local mx, my = love.mouse.getX(), love.mouse.getY()
  if mx > 300 and mx < 500 and my > 500 and my < 560 then active = 1
  else active = 0 end
end

function instructions:draw()
  local mx, my = love.mouse.getX(), love.mouse.getY()
  love.graphics.setColor(230,200,130,itemsc.a)
  love.graphics.setFont(fontb)
  love.graphics.printf("eliminate bugs",300,270,200,"center")
  love.graphics.printf("catch memory leaks",300,320,200,"center")
  love.graphics.printf("glowing rings show your energy",300,390,200,"center")
  if active == 1 then
    love.graphics.setColor(120,80,10,itemsc.a)
    love.graphics.printf("back to main menu",300,500,200,"center")
    love.graphics.setColor(230,200,130,itemsc.a)
  else love.graphics.printf("back to main menu",300,500,200,"center") end
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(cross,mx,my,0,1,1,30,30)
end

return instructions