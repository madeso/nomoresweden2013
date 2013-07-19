

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
	love.graphics.setColor(255, 255, 255)
end

function EndPrint()
	love.graphics.setColor(255, 255, 255)
end

function SetDefaultColor()
	love.graphics.setColor(255, 255, 255)
end

function SetColor(v)
	if v == 0 then
		love.graphics.setColor(255, 0, 0)
	elseif v == 1 then
		love.graphics.setColor(0, 255, 0)
	elseif v == 2 then
		love.graphics.setColor(0, 0, 255)
	else
		love.graphics.setColor(255, 255, 255)
	end
end

function mod3(x)
	if x >= 3 then
		return 0
	elseif x < 0 then
		return 2
	end
	return x
end

function RStat()
	--return 0
	return math.random(3)-1
end

function love.load()
	love.graphics.setFont(love.graphics.newFont("PressStart2P.ttf", 20))
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
	SetState(STATECRAFT)
	
	p1data = {RStat(),RStat(),RStat(),RStat(),RStat()}
	p2data = {RStat(),RStat(),RStat(),RStat(),RStat()}
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

local gfxbox = Img("assets/box.png")

--------------------------------------------------

local p1left = "a"
local p1right = "d"
local p1down = "s"
local p1up = "w"
local p1action = "q"

local p2left = "left"
local p2right = "right"
local p2down = "down"
local p2up = "up"
local p2action = "return"

--------------------------------------------------

function title_setup()
end

function title_draw()
	BeginPrint()
		Print("The game", 300, 100)
	EndPrint()
end

function title_onkey(key, down)
	if down==false then
		if key == " " then
			SetState(STATECRAFT)
		end
	end
end



function title_update(dt)
end

MODTITLES = {"Shape", "Color", "Hull", "Weapon", "Flaw"}
MODDESC = {{"The BOX is a easy shape to furnish.", "The TRIANGLE blends standard ship design and powerful attack vectors.", "The CIRCLE shape is powerful, the enemy doesn't know what way you're facing."}, {"RED is the color of a angry romulan warbird.", "GREEN is the color of peace.", "BLUE is a kinda nice color."}, {"WOOD may not be the best material to build a spaceship of but it's cheap and pretty durable", "IRON is the material most cruisers are made of, but they are slow because of it.", "GLASS is really fragile but also really light"}, {"The ROCKETS are powerful and reliable for a first craft owner.", "The ATOM BOMB is a truly devestating weapon but it also takes time to reload.", "The SLINGSHOT might not be the most dangerous weapon but it takes no time to reload"}, {"FRAGILE: The architect was lazy and didn't really consider structural integrity.", "WEAK ENGINE: The mechanics has made a engine that is weak, it might even be too weak.", "HEAT PROBLEM: The engineers forgot to install proper cooling. The heat from the engine and guns will be a problem and there is no excuse for that."}}

	--------------------------------------------------
	local p1place = 0
	p1data = {0,0,0,0,0}
	local p1craftready = false
	local p2place = 0
	p2data = {0,0,0,0,0}
	local p2craftready = false
	
	function craft_setup()
		p2place = 0
	end

	local TEXTWIDTH = 300

	function craft_draw_player(ready,data,place,x,d,tx,align)
		for i=0, 4 do
			local y = 10+i*110
			SetColor(data[i+1])
			Draw(gfxbox, x, y)
			if ready == false then
			if place == i then
				SetColor(mod3(data[place+1]-1))
				Draw(gfxbox, x+d*110, y)
				SetColor(mod3(data[place+1]+1))
				Draw(gfxbox, x+d*110*2, y)
			end
		end
			SetDefaultColor()
		end
		
		BeginPrint()
			if ready then
				love.graphics.printf(" < R E A D Y > ", tx, 500, TEXTWIDTH, "center")
			else
				love.graphics.printf(MODTITLES[place+1] .. ":", tx, 100, TEXTWIDTH, align)
				love.graphics.printf(MODDESC[place+1][data[place+1]+1], tx, 120, TEXTWIDTH, align)
			end
		EndPrint()
	end

	function craft_draw()
		craft_draw_player(p1craftready, p1data,p1place,10,1,120,"left")
		craft_draw_player(p2craftready, p2data,p2place,690,-1,680-TEXTWIDTH,"right")
	end

	function craft_onkey(key, down)
		if down then
			if p1craftready == false then
			if key == p1up then
				p1place = p1place - 1
			end
			if key == p1down then
				p1place = p1place + 1
			end
			if p1place == -1 then
				p1place = 4
			end
			if p1place == 5 then
				p1place = 0
			end
			if key == p1left then
				p1data[p1place+1] = mod3(p1data[p1place+1]-1)
			end
			if key == p1right then
				p1data[p1place+1] = mod3(p1data[p1place+1]+1)
			end
		end
			if key == p1action then
				p1craftready = not p1craftready
			end
			
			if p2craftready == false then
			if key == p2up then
				p2place = p2place - 1
			end
			if key == p2down then
				p2place = p2place + 1
			end
			if p2place == -1 then
				p2place = 4
			end
			if p2place == 5 then
				p2place = 0
			end
			if key == p2left then
				p2data[p2place+1] = mod3(p2data[p2place+1]+1)
			end
			if key == p2right then
				p2data[p2place+1] = mod3(p2data[p2place+1]-1)
			end
		end
			if key == p2action then
				p2craftready = not p2craftready
			end
		end
	end

	function craft_update(dt)
		if p1craftready and p2craftready then
			SetState(STATEGAME)
		end
	end

---------------------------------------------------

function game_setup()
end
	
function game_draw()
	BeginPrint()
		Print("Let the games begin!", 400, 300)
	EndPrint()
end

function game_onkey(key,down)
end
	
function game_update(dt)
end

---------------------------------------------------


function SetState(nextstate)
	state = nextstate
	PauseAllAudio()
	if state == STATETITLE then title_setup()
	elseif state == STATECRAFT then craft_setup()
	elseif state == STATEGAME then game_setup()
	else
		print("unknown gamestate " .. state)
	end
end

function love.draw()
	if state == STATETITLE then title_draw()
	elseif state == STATECRAFT then craft_draw()
	elseif state == STATEGAME then game_draw()
	else
		BeginPrint()
		love.graphics.print("unknown gamestate " .. state, 400, 300)
		EndPrint()
	end
end

function love.keypressed(key)
	print("Key pressed " .. key)
	if state == STATETITLE then title_onkey(key, true)
	elseif state == STATECRAFT then craft_onkey(key, true)
	elseif state == STATEGAME then game_onkey(key, true)
	else
		print("unknown gamestate " .. state)
	end
end
	
function love.keyreleased(key)
	if key == "escape" then
		love.event.push("quit")   -- actually causes the app to quit
		elseif key == "<" then
			love.graphics.toggleFullscreen()
	end
	
	if state == STATETITLE then title_onkey(key, false)
	elseif state == STATECRAFT then craft_onkey(key, false)
	elseif state == STATEGAME then game_onkey(key,false)
	else
		print("unknown gamestate " .. state)
	end
end

function love.update(dt)
	if state == STATETITLE then title_update(dt)
	elseif state == STATECRAFT then craft_update(dt)
	elseif state == STATEGAME then game_update(dt)
	else
		print("unknown gamestate " .. state)
	end
end

