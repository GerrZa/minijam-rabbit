function love.load()
    delta = 0
end

function love.update(dt)
    delta = dt
end

function love.draw()
    love.graphics.print(tostring(love.timer.getFPS()),0,0)
end