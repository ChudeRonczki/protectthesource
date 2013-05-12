local gamestate = require "lib/gamestate"
local tween = require "lib/tween"

local credits = {}

local itemsc = {a = 0}
local tid
local active = 0
local switching = false

function credits:enter()
  tid = tween(3,itemsc,{a=255},"outQuad")
end

function credits:leave()
  switching = false
end

function credits:load()
end

function credits:keypressed(key)
  if key == "escape" and not switching then 
    switching = true
    tween.stop(tid)
    drop:stop()
    drop:play()
    tween(2,itemsc,{a=0},"inQuad",function() gamestate.switch(require "menu") end)
  end
end

function credits:mousepressed(x,y,key)
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

function credits:update(dt)
  local mx, my = love.mouse.getX(), love.mouse.getY()
  if mx > 300 and mx < 500 and my > 500 and my < 560 then active = 1
  else active = 0 end
end

function credits:draw()
  batch:unbind()
  love.graphics.draw(batch)
  batch:clear()
  local mx, my = love.mouse.getX(), love.mouse.getY()
  love.graphics.setColor(230,200,130,itemsc.a)
  love.graphics.setFont(fontb)
  love.graphics.printf("game by\nlukasz czyzycki",300,250,200,"center")
  love.graphics.printf("art consultant ewa golonka",300,320,200,"center")
  love.graphics.printf("theme music\nfortadelis - escapism\nlicensed under cc",250,390,300,"center")
  if active == 1 then
    love.graphics.setColor(120,80,10,itemsc.a)
    love.graphics.printf("back to main menu",300,500,200,"center")
    love.graphics.setColor(230,200,130,itemsc.a)
  else love.graphics.printf("back to main menu",300,500,200,"center") end
  love.graphics.setColor(255,255,255,255)
  love.graphics.drawq(t1,cross,mx,my,0,1,1,30,30)
end

return credits