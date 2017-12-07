--loading assets

player1 = love.graphics.newImage("img/player.png")
gf1 = love.graphics.newImage("img/gf1.png")
stage = love.graphics.newImage("img/stagev3.png")
mainMenuBackground = love.graphics.newImage("img/mainmenu.png")
limo = love.graphics.newImage("img/limo_ref.png")
phoneNote = love.graphics.newImage("img/phonenumber.png")
phone = love.graphics.newImage("img/phone.png")

--initialising sounds and music
mainMenuMusic = love.audio.newSource("snd/mainmenu.wav")
jumpSound = love.audio.newSource("snd/jump.wav", "static")