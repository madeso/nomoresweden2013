

-- Aliases
local Draw = love.graphics.draw
local PauseAllAudio = love.audio.pause
local Print = love.graphics.print

function Play(x)
	x:rewind()
	love.audio.play(x)
end

function Img(p)
	local r
	r = love.graphics.newImage(p)
	return r
end

function Music(p)
	local s
	s = love.audio.newSource(p, "stream")
	return s
end

function Sfx(p)
	local s
	s = love.audio.newSource(p, "static")
	return s
end

function BeginPrint()
	if worldindex == 1 then
		love.graphics.setColor(0, 0, 0)
	end
end

function EndPrint()
	love.graphics.setColor(255, 255, 255)
end

function love.load()
	love.graphics.setFont(love.graphics.newFont("PressStart2P.ttf", 20))
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
	SetState(STATETITLE)
end

--------------------------------------------------

STATENULL = 0
STATESETUP = 1
STATETITLE = 2
STATECRAFT = 3
STATEGAME = 4
STATESTATE = 6


state = STATENULL
--------------------------------------------------

function title_setup()
end

function title_draw()
	BeginPrint()
		Print("The game", 300, 100)
	EndPrint()
end

function title_onkey(key)
	if key == " " then
		SetState(STATECRAFT)
	end
end

function title_update(dt)
end

	--------------------------------------------------

	function craft_setup()
	end

	function craft_draw()
		BeginPrint()
			Print("Craft setup", 300, 100)
		EndPrint()
	end

	function craft_onkey(key)
	end

	function craft_update(dt)
	end

---------------------------------------------------

function SetState(nextstate)
	state = nextstate
	PauseAllAudio()
	if state == STATETITLE then title_setup()
	elseif state == STATECRAFT then craft_setup()
	else
		print("unknown gamestate " .. state)
	end
end

function love.draw()
	if state == STATETITLE then title_draw()
	elseif state == STATECRAFT then craft_draw()
	else
		BeginPrint()
		love.graphics.print("unknown gamestate " .. state, 400, 300)
		EndPrint()
	end
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.push("quit")   -- actually causes the app to quit
	end
	
	if state == STATETITLE then title_onkey(key)
	elseif state == STATECRAFT then craft_onkey(key)
	else
		print("unknown gamestate " .. state)
	end
end

function love.update(dt)
	if state == STATETITLE then title_update(dt)
	elseif state == STATECRAFT then craft_update(dt)
	else
		print("unknown gamestate " .. state)
	end
end

