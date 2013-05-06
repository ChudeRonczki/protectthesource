local logo = require "logo"
local gamestate = require "lib/gamestate"
local tween = require "lib/tween"

local menu = {}

local itemsc = {a = 0}
local tid
local active = 0
local switching = false

function menu:enter()
  logo:show()
  tid = tween(3,itemsc,{a=255},"outQuad")
end

function menu:leave()
  switching = false
end

function menu:load()
end

function menu:keypressed(key)
  if key == "escape" then love.event.quit() end
end

function menu:mousepressed(x,y,key)
  if key == "l" and not switching and active ~= 0 then
    switching = true
    tween.stop(tid)
    drop:stop()
    drop:play()
    if active == 1 then
      logo:hide()
      tween(2,itemsc,{a=0},"inQuad",function() gamestate.switch(require "gameplay") end)
    elseif active == 2 then
      tween(2,itemsc,{a=0},"inQuad",function() gamestate.switch(require "instructions") end)
    elseif active == 3 then
      tween(2,itemsc,{a=0},"inQuad",function() gamestate.switch(require "credits") end)
    elseif active == 4 then
      love.event.quit()
    end
  end
end

function menu:update(dt)
  local mx, my = love.mouse.getX(), love.mouse.getY()
  if mx > 300 and mx < 500 then
    if my > 300 then
      if my < 330 then active = 1
      elseif my < 360 then active = 2
      elseif my < 390 then active = 3
      elseif my < 420 then active = 4
      else active = 0 end
    else active = 0 end
  else active = 0 end
end

function menu:draw()
  local mx, my = love.mouse.getX(), love.mouse.getY()
  love.graphics.setColor(230,200,130,itemsc.a)
  love.graphics.setFont(fontb)
  if active == 1 then
    love.graphics.setColor(120,80,10,itemsc.a)
    love.graphics.printf("play",300,300,200,"center")
    love.graphics.setColor(230,200,130,itemsc.a)
  else love.graphics.printf("play",300,300,200,"center") end
  if active == 2 then
    love.graphics.setColor(120,80,10,itemsc.a)
    love.graphics.printf("instructions",300,330,200,"center")
    love.graphics.setColor(230,200,130,itemsc.a)
  else love.graphics.printf("instructions",300,330,200,"center") end
  if active == 3 then
    love.graphics.setColor(120,80,10,itemsc.a)
    love.graphics.printf("credtis",300,360,200,"center")
    love.graphics.setColor(230,200,130,itemsc.a)
  else love.graphics.printf("credtis",300,360,200,"center") end
  if active == 4 then
    love.graphics.setColor(120,80,10,itemsc.a)
    love.graphics.printf("exit",300,390,200,"center")
    love.graphics.setColor(230,200,130,itemsc.a)
  else love.graphics.printf("exit",300,390,200,"center") end
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(cross,mx,my,0,1,1,30,30)
end

return menu