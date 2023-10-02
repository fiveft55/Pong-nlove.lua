-- Pong in love.lua

function love.load()
    -- window config
    winW, winH, winTitle = 800, 600, "Pong in lua"

    love.window.setMode(winW, winH)
    love.window.setTitle(winTitle)

    -- paddles config
    paddle = {
        width = 10,
        height = 80,
    }
    ballSize = 10

    -- Players config
    local midLoc = winH /2 - paddle.height /2
    playOne, playTwo = {
        x = 50,
        y = midLoc,
        dy = 0,
        speed = 300
    }, {
        x = winW - 50 - paddle.width, -- it's at right
        y = midLoc,
        dy = 0,
        speed = 300
    }

    -- ball config
    ball = {
        x = winW /2 - ballSize /2,
        y = winH /2 - ballSize /2,
        dx = 200,
        dy = 200
    }

    -- scores.variables
    scorePONE, scorePTWO = 0, 0

end

function love.update(dt)
    -- AI CTRL Setup
    local ballCenterY = ball.y + ballSize /2
    local player1Y = playOne.y + paddle.height /2
    local player2Y = playTwo.y + paddle.height /2

    -- Adjust paddle to the ball pos
    if ball.x < winW /2 then
        if ballCenterY < player1Y then
            playOne.dy = -playOne.speed
        elseif ballCenterY > player1Y then
            playOne.dy = playOne.speed
        else
            playOne.dy = 0
        end
    else
        playOne.dy = 0
    end
    -- player one ^ and two .>
    if ball.x > winW /2 then
        if ballCenterY < player2Y then
            playTwo.dy = -playTwo.speed
        elseif ballCenterY > player2Y then
            playTwo.dy = playTwo.speed
        else
            playTwo.dy = 0
        end
    else
        playTwo.dy = 0
    end

    -- paddle-move
    playOne.y = playOne.y + playOne.dy * dt
    playTwo.y = playTwo.y + playTwo.dy * dt

    -- limit over-cross
    playOne.y = math.min(math.max(playOne.y, 0), winH - paddle.height)
    playTwo.y = math.min(math.max(playTwo.y, 0), winH - paddle.height)

    -- ball-move
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- ball-move -- collision window
    if ball.y < 0 or ball.y + ballSize > winH then
        ball.dy = -ball.dy
    end

    -- ball-move -- collision paddle -- spaghetti code
    if ball.x < playOne.x + paddle.width and  ball.x + ballSize > playOne.x and ball.y < playOne.y + paddle.height and ball.y + ballSize > playOne.y then
        ball.dx = -ball.dx
    end

    if ball.x < playTwo.x + paddle.width and ball.x + ballSize > playTwo.x and ball.y < playTwo.y + paddle.height and ball.y + ballSize > playTwo.y then
        ball.dx = -ball.dx
    end

    -- ball out-score
    if ball.x < 0 then
        scorePTWO = scorePTWO + 1
        resetBall()
    elseif ball.x + ballSize > winW then
        scorePONE = scorePONE + 1
        resetBall()
    end

end -- end is here

-- reset func 
function resetBall()
    ball.x = winW /2 - ballSize /2
    ball.y = winH /2 - ballSize /2
    ball.dx = 200
    ball.dy = 200
end

-- darw game
function love.draw()
    -- Set bgcolor
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Draw paddles
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", playOne.x, playOne.y, paddle.width, paddle.height)
    love.graphics.rectangle("fill", playTwo.x, playTwo.y, paddle.width, paddle.height)

    -- ball
    love.graphics.rectangle("fill", ball.x, ball.y, ballSize, ballSize)

    -- line
    local x1, y1, x2, y2 = winW /2, 0 , winW /2, winH
    love.graphics.line(x1, y1, x2, y2)

    -- the score
    love.graphics.print("Player 1: " .. scorePONE, 50, 10)
    love.graphics.print("Player 2: " .. scorePTWO, winW - 150, 10)
end
