--initilaise car object
--state 1 coming
--state 2 waiting
--state 3 leaving
--state 4 not in game
limousine = {x = 600, y = 750, lane = 1, state = 4}

  --game lanes init
lanes = {
    {status = 0, phoneNumberChallenge = 0, textingChallenge = 0, girlfriendChallenge = 0, challengeTimer = 0},
    {status = 0, phoneNumberChallenge = 0, textingChallenge = 0, girlfriendChallenge = 0, challengeTimer = 0},
    {status = 0, phoneNumberChallenge = 0, textingChallenge = 0, girlfriendChallenge = 0, challengeTimer = 0},
    {status = 0, phoneNumberChallenge = 0, textingChallenge = 0, girlfriendChallenge = 0, challengeTimer = 0}
}

--Lane statuses
--0 = empty = player.gameScore + 0
--1 = receiving phone number = player.gameScore + 100
--2 = texting = player.gameScore + 50
--3 = incoming gf = player.gameScore + 150

--Placing crowd objects
crowdMember = 
{
    {x = 1 , y = 1, r = 1 , g = 1 , b = 1}  
}
generateCrowd()


--initialise note
--state 1 sending
--state 2 collected
--state 3 missed
--state 4 out of game
note = {x = 840, state = 1, lane = 1} 

--initialise phone
--state 1 waiting
--state 2 text
--state 3 reset
--state 4 timeout
textingPhone = {x = 840, state = 1, lane = 1, timeout = 1, progress = 1}


--initialise gamestates
gameState = {MainMenu = true, Game = false, ScoreScreen = false}

--initialise player object
player = {name = "OBEY1", checkpoint = 1, sprite = "player1", gameScore = 0, x = 160, y = 80, phoneNumbers = 0}
  