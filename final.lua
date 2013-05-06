local gamestate = require "lib/gamestate"
local tween = require "lib/tween"

local final = {}

local itemsc = {a = 0}
local tid
local switching = false
local score

function final:enter(_,points)
  score = tostring(points)
  tid = tween(3,itemsc,{a=255},"outQuad")
end

function final:leave()
  switching = false
end

function final:load()
end

function final:keypressed(key)
  if not switching then 
    switching = true
    tween.stop(tid)
    drop:stop()
    drop:play()
    tween(2,itemsc,{a=0},"inQuad",function() gamestate.switch(require "menu") end)
  end
end

function final:draw()
  local mx, my = love.mouse.getX(), love.mouse.getY()
  love.graphics.setColor(230,200,130,itemsc.a)
  love.graphics.setFont(fontb)
  love.graphics.printf("your score",300,260,200,"center")
  love.graphics.printf(score,300,290,200,"center")
  love.graphics.printf("press any key",250,390,300,"center")
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(cross,mx,my,0,1,1,30,30)
end

return final