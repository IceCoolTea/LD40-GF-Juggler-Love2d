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
            if lanes[k].status == 1 and note.x > 600 then
                note.state = 1
                note.x = 600
                --state 1 sending
                if note.x <= 600 and note.state == 1 then
                    note.x = note.x - challengeSpeed * delta
                end
                 --state 2 collected????
                if note.state == 1 and note.x <= 110 and note.x >= 90 and playerAtNote then
                    note.state = 4
                    scoreGet(100)
                    phoneNumberGet()
                    lanes[k].status = 0 --this might not wreck things
                    --TODO play some sound
                else
                    note.state = 3
                end
                --state 3 missed
                if note.state == 3 then
                    note.x = note.x - challengeSpeed * delta
                    if note.x == -30 then
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
                lanes[k].textingChallenge = lanes[k].textingChallenge + challengeSpeed * delta
                if player.checkpoint == k then
                    lanes[k].challengeTimer = lanes[k].challengeTimer + (challengeSpeed * 1.3) * delta
                    if lanes[k].challengeTimer == 100 then
                        scoreGet(50)
                        lanes[k].status = 0
                        lanes[k].textingChallenge = 0
                        lanes[k].challengeTimer = 0
                    end
                    if lanes[k].challengeTimer < 100 and lanes[k].textingChallenge >= 100 then
                        lanes[k].status = 3
                        lanes[k].textingChallenge = 0
                        lanes[k].challengeTimer = 0
                    end
                else
                    lanes[k].challengeTimer = 0
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