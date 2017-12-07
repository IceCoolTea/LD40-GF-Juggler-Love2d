function love.load()
  -- Main LOVE settings
  require("conf")

  --loading assets
  require("loadAssets")

  --initialise game objects
  require("gameObjects")

  --load game settings
  require("gameSettings")
  
  --testing lane states
  --lanes[love.math.random(1,4)].status = 2  
  lanes[3].status = 2 

end

--draw limousine
function drawLimoAtLane(delta)
  if limousine.state == 1 then
    limoUp(delta)
    if limousine.y <= limoLane() then
      limousine.state = 2
    end
  end
  if limousine.state == 2 then
    limoUpSlow(delta)
    local limoStuff = limoLane() - 7
    if limousine.y <= limoStuff then
      limousine.state = 3
    end
  end
  if limousine.state == 3 then
    limoUp(delta)
    if limousine.y <= -300 then
      limousine.state = 4
    end
  end
  if limousine.state == 4 then
    limousine.y = 1000
  end
end

--limo slows down to eject passenger
function limoUpSlow(delta)
  limousine.y = limousine.y - 5 * delta
end

--limo max speed
function limoUp(delta)
  limousine.y = limousine.y - 1000 * delta
end

--calculate limo stop at which lane
function limoLane()
  return ((limousine.lane * 110) - 180)
end

--crowd creator function
function generateCrowd()
  for i = 1, 50 do
    table.insert( crowdMember, { 
      x = love.math.random(210, 590),
      y = love.math.random(1, 10) - 60,
      r = love.math.random(1, 254),
      g = love.math.random(1, 254),
      b = love.math.random(1, 254),
      hr = love.math.random(1, 254),
      hg = love.math.random(1, 254),
      hb = love.math.random(1, 254)
    } )
  end
  for i = 51, 150 do
      table.insert( crowdMember, { 
      x = love.math.random(722, 800),
      y = love.math.random(0, 600) - 60,
      r = love.math.random(1, 254),
      g = love.math.random(1, 254),
      b = love.math.random(1, 254),
      hr = love.math.random(1, 254),
      hg = love.math.random(1, 254),
      hb = love.math.random(1, 254)
    } )
  end
  for i = 151, 200 do
    table.insert( crowdMember, { 
      x = love.math.random(200, 590),
      y = love.math.random(390, 430),
      r = love.math.random(1, 254),
      g = love.math.random(1, 254),
      b = love.math.random(1, 254),
      hr = love.math.random(1, 254),
      hg = love.math.random(1, 254),
      hb = love.math.random(1, 254)
    } )
    --crowdMember[i].x = love.math.random(210, 590)
    --crowdMember[i].y = love.math.random(1, 10) - 60
  end
end

--game update
function love.update(dt)
  if gameState.Game then
    laneControl(dt)
    drawLimoAtLane(dt)
  end
  if gameState.MainMenu then
    laneControl(dt)
    mainMenuMusic:play()

  end
  if gameState.ScoreScreen then
    laneControl(dt)
  end
end

--Main menu crap
function drawMainMenu()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(mainMenuBackground, 0, 0)
  love.graphics.setColor(0, 200, 0)
  love.graphics.setColor(255, 255, 255)
end

--as the name suggests
function drawCrowd()
  for i = 2, 200 do
    drawCrowdMember(i)
  end
end

--colorize crowd members
function drawCrowdMember(index)
  love.graphics.setColor(crowdMember[index].r, crowdMember[index].g, crowdMember[index].b)
  love.graphics.rectangle("fill", crowdMember[index].x, crowdMember[index].y + 15, 20, 55)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setColor(crowdMember[index].hr, crowdMember[index].hg, crowdMember[index].hb)
  love.graphics.circle("fill", crowdMember[index].x + 10, crowdMember[index].y + 10, 10)
  love.graphics.setColor(255, 255, 255)
end

--controls and quit
function love.keypressed(key)
  if gameState.Game then
    if key == "up" then
      player.checkpoint = player.checkpoint - 1
      jumpSound:stop()
      jumpSound:play()
    end
    if key == "down" then
      player.checkpoint = player.checkpoint + 1
      jumpSound:stop()
      jumpSound:play()
    end
    
    if player.checkpoint > 4 then
      player.checkpoint = 4
    end
    if player.checkpoint < 1 then
      player.checkpoint = 1
    end
  end
  if gameState.MainMenu then
    if key == "return" then
      gameState.MainMenu = false
      gameState.Game = true
      mainMenuMusic:stop()
      crowdDrawing = true

    end
    if key == "escape" then
      love.event.push("quit")
    end
  end
  if gameState.ScoreScreen then
    if key == "return" then
      gameState.MainMenu = true
      gameState.ScoreScreen = false
    end
  end
  if key == "escape" then
    gameState.MainMenu = true
    gameState.ScoreScreen = false
    gameState.Game = false
  end
end

--endless mess of drawing queue
function love.draw()
  if gameState.MainMenu then
    drawMainMenu()
  end
  if gameState.Game then
    drawStage()
    drawBoyfriend()
    drawScore()
    drawPhoneNumbers()
    drawTextingChallenge()
    drawCrowd()
    drawLimo()
    drawPhone()
  end
end

--drawing limo sprite
function drawLimo()
  love.graphics.draw(limo, limousine.x, limousine.y)
end

--add score value
function scoreGet(value)
  player.gameScore = player.gameScore + value
end

--Lane logic here
function laneControl(delta)
  if gameState.Game then  
    for k, v in pairs(lanes) do 
          --STATUS 0 = empty = player.gameScore + 0
          if lanes[k].status == 0 then
              lanes[k].phoneNumberChallenge = 0
              lanes[k].textingChallenge = 0
              lanes[k].girlfriendChallenge = 0
          end
         
          --STATUS 1 = receiving phone number = player.gameScore + 100
          if lanes[k].status == 1 then 
            --and note.x > 600 then
              note.state = 1
              if note.x > 600 and note.state == 1 then
                note.lane = k
                note.x = 600
              end
              --state 1 sending
              if note.x <= 600 and note.state == 1 then
                  note.x = note.x - challengeSpeed * delta
              end
               --state 2 collected????
              if note.state == 1 and note.x <= 170 and note.x >= 150 and playerAtNote then
                  note.state = 4
                  scoreGet(100)
                  phoneNumberGet()
                  --TODO play some sound
              else
                  note.state = 3
              end
              --state 3 missed
              if note.state == 3 then
                  note.x = note.x - challengeSpeed * delta
                  if note.x <= -30 then
                  note.state = 4
                  end
              end
              --[[if playerAtNote and note.state == 2 then
                  note.state = 4
              end]]
              --state 4 out of game
              if note.state == 4 then
                  note.x = 840
                  lanes[k].status = 0 --this might not wreck things
              end 
          end 

          --STATUS 2 = texting = player.gameScore + 50
          if lanes[k].status == 2 then
            textingPhone.state = 1
            if textingPhone.x > 190 and textingPhone.state == 1 then
              textingPhone.x = 190
              textingPhone.lane = k
              textingPhone.timeout = textingPhone.timeout + (challengeSpeed + 50) * delta
            end
            --state 1 texting
            if player.checkpoint == 1 and note.state == 1 then
              textingPhone.progress = textingPhone.progress + challengeSpeed * delta
            end
            if textingPhone.state == 1 and textingPhone.progress >= 100 and textingPhone.timeout < 100 then
              --play sound
              scoreGet(50)
              textingPhone.state = 3
              lanes[k].status = 0
            end
            if textingPhone.state == 1 and textingPhone.progress < 100 and textingPhone.timeout >= 100 then
              --play lose sound
              textingPhone.state = 3
              lanes[k].status = 3
            end
            if textingPhone.state == 3 then
              textingPhone.x = 850
            end
          end
  
          --STATUS 3 = incoming gf = player.gameScore + 150
          if lanes[k].status == 3 then
              lanes[k].girlfriendChallenge = lanes[k].girlfriendChallenge + challengeSpeed * delta
              if player.checkpoint == k - 1 then
                  lanes[k].challengeTimer = lanes[k].challengeTimer + (challengeSpeed * 1.2) * delta
                  if challengeTimer == 100 then
                      scoreGet(50)
                      lanes[k].status = 0
                      lanes[k].girlfriendChallenge = 0
                      lanes[k].challengeTimer = 0
                  end
              else
                  lanes[k].challengeTimer = 0
                  lanes[k].girlfriendChallenge = 0
                  lanes[k].status = 0
                  gameState.Game = false
                  gameState.ScoreScreen = true
              end
          end
      end
  end
end
--[[
function phoneNumberLogic(delta)
  --state 1 sending
  --state 2 collected
  --state 3 missed
  --state 4 out of game
  if note.state == 1 and note.x > 600 then
    note.x = 600
  end
  if note.state == 1 and note.x <= 600 then
    note.x = note.x - challengeSpeed * delta
  end
  if note.state == 1 and note.x <= 110 and note.x >= 90 and playerAtNote then
    note.state = 2
    scoreGet(100)
    phoneNumberGet()
    --lanes[note.lane].status = 0 --this gonna wreck things
    --TODO play some sound
  else
    note.state = 3
  end
  if note.state == 3 then
    note.x = note.x - challengeSpeed * delta
    if note.x == -30 then
      note.state = 4
      note.x = 840
    end
  end
  if playerAtNote and note.state == 2 then
    note.state = 4
    note.x = 840
  end
  if note.state == 4 then
    note.x = 840
  end
end
]]
--add one phone number to the player
function phoneNumberGet()
  player.phoneNumbers = player.phoneNumbers + 1 
end

--draw phone on stage
function drawPhone()
  love.graphics.draw(phone, textingPhone.x, (textingPhone.lane * 100) - 45)
  love.graphics.setColor(255, 255, 0)
  love.graphics.circle("line",textingPhone.x + 7, (textingPhone.lane * 100) - 35, 13)
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("line", textingPhone.x - 12, (textingPhone.lane * 100), textingPhone.timeout, 10 )
  love.graphics.setColor(255, 255, 255)
end

--is the player at the same lane as note
function playerAtNote()
  return player.checkpoint == note.lane
end

function drawPhoneNumbers()
  local y = (note.lane * 100) - 20
  love.graphics.draw(phoneNote, note.x, y)
  --[[Lane 1 phonenumber logic
  --if Lane1.status == 1 then
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle("fill", lanes[1].textingChallenge, 70, 20, 10 )
  love.graphics.setColor(255, 255, 255)
  --end]]
end

function drawTextingChallenge()
  --[[Lane 1 texting challenge logic
  --if Lane1.status == 2 then
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", 200, 70, lanes[1].textingChallenge, 10 )
  love.graphics.setColor(0, 255, 255)
  love.graphics.rectangle("fill", 585, 90,  lanes[1].textingChallenge - 585 , 10 )
  love.graphics.setColor(255, 255, 255)
  --end]]
end

--debugging stuff
function drawScore()
  love.graphics.setColor(0, 200, 0)
  love.graphics.print("player.gameScore: " .. player.gameScore .. " Numbers: " .. player.phoneNumbers, 50, 520)
  love.graphics.print("Lane1: " .. lanes[1].textingChallenge .. " Status: " .. lanes[1].status, 50, 530)
  love.graphics.print("Lane2: " .. lanes[2].phoneNumberChallenge .. " Status: " .. lanes[2].status, 50, 540)
  love.graphics.print("Lane2: " .. lanes[3].textingChallenge .. " Status: " .. lanes[3].status, 50, 550)
  love.graphics.print("Limo: " .. limousine.y .. " Status: " .. limousine.state, 50, 560)
  love.graphics.setColor(255, 255, 255)
end

--this had to be a function :)
function drawStage()
  love.graphics.draw(stage, 0, 0)
end

--hello weirdo
function drawBoyfriend()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(player1, player.x, (player.checkpoint * 100) - 90)
end

function love.quit()
  -- wut
end