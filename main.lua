ATL_Loader = require("AdvTiledLoader.Loader")
ATL_Loader.path = "assets/"

SHIPRADIUS = 7
FORCE = 15000
UPFORCE = 3*FORCE
DOWNFORCE = FORCE/2
DENSITY = 200
METERS = 10
GRAVITY = 35
BOUNCY = 0.4
FRICTION = 0.5

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

map = nil
world = nil

function addRect(x,y,w,h)
	local xx = x + w/2
	local yy = y + h/2
	local body = love.physics.newBody(world,xx,yy,"static")
	local shape = love.physics.newRectangleShape(w,h)
	local fix = love.physics.newFixture(body, shape, 1)
	fix:setFriction(FRICTION)
end
	
function addShip(x,y)
	local body = love.physics.newBody(world,x,y,"dynamic")
	local shape = love.physics.newCircleShape(SHIPRADIUS)
	local fix = love.physics.newFixture(body, shape, DENSITY)
	fix:setRestitution(BOUNCY)
	fix:setFriction(FRICTION)
	return body
end

function love.load()
	love.mouse.setVisible(false)
	love.graphics.setFont(love.graphics.newFont("PressStart2P.ttf", 20))
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
	SetState(STATETITLE)
	love.physics.setMeter(METERS)
	
	p1data = {RStat(),RStat(),RStat(),RStat(),RStat()}
	p2data = {RStat(),RStat(),RStat(),RStat(),RStat()}
	
	map = ATL_Loader.load("world.tmx")
	map.useSpriteBatch = true
	map.drawObjects = false
		
	world = love.physics.newWorld(0,GRAVITY,false)
		p1body = addShip(300, 30)
		p2body = addShip(500, 30)
	for tilename, tilelayer in pairs(map.tileLayers) do
		print("Working on ", tilename, map.height, map.width, tilelayer)
		if tilename == "col" then
			for y=1,map.height do
				for x=1,map.width do
					local tile = tilelayer.tileData(x,y)
					if tile and tile ~= nil then 
						--print(x,y, tilenumber)
						local epsilon = 0.0
						local ctile = addRect((x)* map.tileWidth, (y) * map.tileHeight, map.tileWidth-epsilon, map.tileHeight-epsilon)
						--print("detected collision tile!")
						--ctile.type = nil
						--collider:addToGroup("tiles", ctile)
						--collider:setPassive(ctile)
						--tiles[#self.tiles+1] = ctile
						--added = added + 1
					end
				end
			end
		end
	end
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
local gfxcircle = Img("assets/circle.png")

--------------------------------------------------

p1left = "a"
p1right = "d"
p1down = "s"
p1up = "w"
p1action = "q"
p1start = "e"

p2left = "left"
p2right = "right"
p2down = "down"
p2up = "up"
p2action = "return"
p2start = "rshift"
	
function setkeyboard()
	p1left = "a"
	p1right = "d"
	p1down = "s"
	p1up = "w"
	p1action = "q"
	p1start = "e"

	p2left = "left"
	p2right = "right"
	p2down = "down"
	p2up = "up"
	p2action = "return"
	p2start = "rshift"
end

function setgamepads()
	local p1 = "joy1."
	p1left = p1.."-ax4"
	p1right = p1.."+ax4"
	p1down = p1.."+ax5"
	p1up = p1.."-ax5"
	p1action = p1.."btn3"
	p1start = p1.."btn4"

	local p2 = "joy2."
	p2left = p2.."-ax4"
	p2right = p2.."+ax4"
	p2down = p2.."+ax5"
	p2up = p2.."-ax5"
	p2action = p2.."btn3"
	p2start = p2.."btn4"
end

function determinesuperkey(key)
	if key == " " then
		return 1
	elseif key == "joy1.btn10" then
		return 2
	elseif key == "joy2.btn10" then
		return 2
	else
		return 0
	end
end

--------------------------------------------------

function title_setup()
	p1craftready = false
	p2craftready = false
end

function title_draw()
	BeginPrint()
		Print("The game", 300, 100)
	EndPrint()
end

function title_onkey(key, down)
	if down==false then
		local super = determinesuperkey(key)
		if super == 1 then
			setkeyboard()
			SetState(STATECRAFT)
		elseif super==2 then
			setgamepads()
			SetState(STATECRAFT)
		end
	end
end



function title_update(dt)
end

MODTITLES = {"Shape", "Color", "Hull", "Weapon", "Flaw"}
MODDESC = {{"The BOX is a easy shape to furnish.", "The TRIANGLE blends standard ship design and powerful attack vectors.", "The CIRCLE shape is powerful, the enemy doesn't know what way you're facing."}, {"RED is the color of a angry romulan warbird.", "GREEN is the color of peace.", "BLUE is a kinda nice color."}, {"WOOD may not be the best material to build a spaceship of but it's cheap and pretty durable", "IRON is the material most cruisers are made of, but they are slow because of it.", "GLASS is really fragile but also really light"}, {"The ROCKETS are powerful and reliable for a first craft owner.", "The ATOM BOMB is a truly devestating weapon but it also takes time to reload.", "The SLINGSHOT might not be the most dangerous weapon but it takes no time to reload"}, {"FRAGILE: The architect was lazy and didn't really consider structural integrity.", "WEAK ENGINE: The mechanics has made a engine that is weak, it might even be too weak.", "HEAT PROBLEM: The engineers forgot to install proper cooling. The heat from the engine and guns will be a problem and there is no excuse for that."}}

--------------------------------------------------
p1place = 0
p1data = {0,0,0,0,0}
p1craftready = false
p2place = 0
p2data = {0,0,0,0,0}
p2craftready = false

function craft_setup()
	p1place = 0
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
			p1hasaction = 0
						p2hasaction = 0
function game_setup()
	p1body:setPosition(200, 50)
	p1body:setPosition(400, 50)
	p1direction = 6
		p1hasaction = 0
	p2direction = 4
		p2hasaction = 0
end
	
function gamedrawship(body, data)
	local x, y = body:getPosition()
	Draw(gfxcircle, x-SHIPRADIUS,y-SHIPRADIUS)
end
	
function game_draw()
	map:draw()
	BeginPrint()
		Print(tostring(p1direction) .. "-" .. tostring(p1hasaction), 100, 100)
	EndPrint()
			
	gamedrawship(p1body, p1data)
	gamedrawship(p2body, p2data)
end

function b2i(b)
	if b then
		return 1
	else
		return -1
	end
end

function game_onkey_ship(body, key, isdown, left, right, up, down, direction, hasaction)
		if key == left then
			if isdown then direction = 4 end
			hasaction = hasaction + b2i(isdown)
		end
		if key == right then
			if isdown then direction = 6 end
			hasaction = hasaction + b2i(isdown)
		end
		if key == up then
			if isdown then direction = 8 end
			hasaction = hasaction + b2i(isdown)
		end
		if key == down then
			if isdown then direction = 2 end
			hasaction = hasaction + b2i(isdown)
		end
	
		return direction, hasaction
end

function game_onkey(key,down)
	if down==false and determinesuperkey(key)>0 then
		SetState(STATETITLE)
	end
	
	p1direction,p1hasaction = game_onkey_ship(p1body, key, down, p1left, p1right, p1up, p1down, p1direction, p1hasaction)
	p2direction,p2hasaction = game_onkey_ship(p2body, key, down, p2left, p2right, p2up, p2down, p2direction, p2hasaction)
end
	
function game_update_ship(body, direction, hasaction)
	if hasaction > 0 then
		if direction == 4 then
			body:applyForce(-FORCE,0)
		end
		if direction == 6 then
			body:applyForce(FORCE,0)
		end
		if direction == 8 then
			body:applyForce(0,-UPFORCE)
		end
		if direction == 2 then
			body:applyForce(0,DOWNFORCE)
		end
	end
end
	
function game_update(dt)
	game_update_ship(p1body, p1direction, p1hasaction)
	game_update_ship(p2body, p2direction, p2hasaction)
	world:update(dt)
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

function onkey(key, down)
	if down == false then
		if key == "escape" then
			love.event.push("quit")   -- actually causes the app to quit
		elseif key == "<" then
				love.graphics.toggleFullscreen()
		end
	end
	print("Key " .. key .. " changed to ".. tostring(down))
	if state == STATETITLE then title_onkey(key, down)
	elseif state == STATECRAFT then craft_onkey(key, down)
	elseif state == STATEGAME then game_onkey(key, down)
	else
		print("unknown gamestate " .. state)
	end
end

function love.keypressed(key)
	onkey(key,true)
end
	
function love.keyreleased(key)
	onkey(key, false)
end

function love.joystickpressed( joystick, button )
	onkey("joy"..tostring(joystick)..".btn"..tostring(button), true)
end

function love.joystickreleased( joystick, button )
	onkey("joy"..tostring(joystick)..".btn"..tostring(button), false)
end

function sendjoykeys()
	local joysticks = love.joystick.getNumJoysticks()

	if js == nil then
		js = {}
		for joystick=1, joysticks do
			local data = {}
			data.axes = love.joystick.getNumAxes(joystick)
			data.axesl = {}
			data.axesr = {}
			for axis=1, data.axes do
				data.axesl[axis] = false
				data.axesr[axis] = false
			end
			js[joystick] = data
		end
	end

	for joystick=1, joysticks do
		local data = js[joystick]
		for axis=1, data.axes do
			local direction = love.joystick.getAxis(joystick, axis)
			local left = false
			local right = false
			if direction > 0.5 then
				right = true
			end
			if direction < -0.5 then
				left = true
			end
			if data.axesl[axis] ~= left then
				data.axesl[axis] = left
				onkey("joy"..tostring(joystick)..".-ax"..tostring(axis), left)
			end
			if data.axesr[axis] ~= right then
				data.axesr[axis] = right
				onkey("joy"..tostring(joystick)..".+ax"..tostring(axis), right)
			end
		end
	end
end


function love.update(dt)
	sendjoykeys()
	if state == STATETITLE then title_update(dt)
	elseif state == STATECRAFT then craft_update(dt)
	elseif state == STATEGAME then game_update(dt)
	else
		print("unknown gamestate " .. state)
	end
end

