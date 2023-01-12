local fakeHealthBar = require 'mods/NoveniBurning/Modules/fakeHealthBar'
local directions = { 'LEFT', 'DOWN', 'UP', 'RIGHT' }

local zoomadd = 0

local swapped = false
local firstHealth = 1
local secondHealth = 1

local stopit = false

local overlayColours = {
  '0xFFFFFFFF',
  '0xFFCCCCFF', 
  '0xFFAAAAFF', 
  '0xFF9999FF', 
  '0xFF6666FF', 
  '0xFF3333FF', 
  '0xFF0000FF', 
  '0xFF000099', 
  '0xFF000066', 
  '0xFF000033', 
  '0xFF000000'
 } --thank you souless dx

local function overlayChange(num)
	if overlayColours[num] then
		setProperty('overlay.color', getColorFromHex(overlayColours[num]))
	end
end

function onCreate()

	makeAnimatedLuaSprite('waterfall', 'stages/egg', -200,-120);
	setLuaSpriteScrollFactor('waterfall', 1, 1);
	addLuaSprite('waterfall', true);
	setObjectOrder('waterfall', 0)
	addAnimationByPrefix('waterfall', 'idlefailsanimation', 'idle', 14, true)
	objectPlayAnimation('waterfall','idlefailsanimation',true);
	scaleObject('waterfall', 10, 10);
	setProperty('waterfall.antialiasing', false);
	
	makeLuaSprite('stageback', 'stages/floor', 0, 0);
	setScrollFactor('stageback',1, 1);
	addLuaSprite('stageback', false);
	scaleObject('stageback', 10, 10);
	setProperty('stageback.antialiasing', false);
	
	makeLuaSprite('backeststage', 'stages/bgbg', 0, -1000);
	setScrollFactor('backeststage',1, 1);
	addLuaSprite('backeststage', false);
	scaleObject('backeststage', 10, 10);
	setProperty('backeststage.antialiasing', false);
	setObjectOrder('backeststage', 0)

	makeAnimatedLuaSprite('introsc', 'extra/introsc', 140,0);
	scaleObject('introsc', 4, 4);
	addLuaSprite('introsc', true);
	setProperty("introsc.visible", true);
	setObjectCamera('introsc', 'other')
	setProperty('introsc.antialiasing', false);
	setObjectOrder('introsc', 3)

	makeLuaSprite('flicker', 'FlickerFlash', 0,0);
	setLuaSpriteScrollFactor('flicker', 0, 0);
	addLuaSprite('flicker', false);
	setObjectOrder('flicker', 2)
	setObjectCamera('flicker', 'other')
	scaleObject('flicker', 6, 6);

	makeLuaSprite('overlay', 'whiteOverlay', 0,0);
	setLuaSpriteScrollFactor('overlay', 0, 0);
	addLuaSprite('overlay', false);
	--setObjectOrder('overlay', 7)
	setObjectCamera('overlay', 'other')
	setBlendMode("overlay", "darken")

	makeLuaSprite('alphabot', 'FlickerFlash', -200,-200);
	setLuaSpriteScrollFactor('alphabot', 0, 0);
	addLuaSprite('alphabot', false);
	setObjectOrder('alphabot', 5)
	setObjectCamera('alphabot', 'other')

end

function onCreatePost()
	setProperty("dad.visible", false)
	setProperty("gf.visible", false)

	local addby = 200
	
	if downscroll then
		addby = -200
	end
		
	for i = 0, 7 do
		local key = (i % 4)
		local name = i > 3 and 'realDefaultPlayerStrum' or 'realDefaultOpponentStrum'
		
		setPropertyFromGroup('strumLineNotes', i, 'x', _G[name .. 'X' .. key])
		setPropertyFromGroup('strumLineNotes', i, 'y', _G[name .. 'Y' .. key] - addby)
	end
	
	for i = 8, 11 do
		local key = (i % 4)
		local name = 'defaultLeftStrum'
		
		setPropertyFromGroup('strumLineNotes', i, 'x', _G[name .. 'X' .. key] + 2000)
	end
	
	makeAnimatedLuaSprite('idlesonic', 'extra/sidle', 420,990);
	setLuaSpriteScrollFactor('idlesonic', 1, 1);
	addLuaSprite('idlesonic', true);
	setObjectOrder('idlesonic', 0)
	addAnimationByPrefix('idlesonic', 'idleanimation', 'idle', 10, true)
	objectPlayAnimation('idlesonic','idleanimation',true);
	scaleObject('idlesonic', 10, 10);
	setObjectOrder('idlesonic', 6)
	setProperty('idlesonic.antialiasing', false);

	makeAnimatedLuaSprite('eggenterance', 'extra/eggenter', 2180,170);
	setLuaSpriteScrollFactor('eggenterance', 1, 1);
	addLuaSprite('eggenterance', true);
	setObjectOrder('eggenterance', 0)
	addAnimationByPrefix('eggenterance', 'idleanimation', 'idle', 14, true)
	objectPlayAnimation('eggenterance','idleanimation',true);
	scaleObject('eggenterance', 10, 10);
	setObjectOrder('eggenterance', 6)
	setProperty('eggenterance.antialiasing', false);
	setProperty("eggenterance.visible", false)

	fakeHealthBar.Init()
	
	setProperty('timeBarBG.y', getProperty('timeBarBG.y') - addby)
	setProperty('timeBar.y', getProperty('timeBar.y') - addby)
	setProperty('timeTxt.y', getProperty('timeTxt.y') - addby)

	setProperty('scoreTxt.y', getProperty('scoreTxt.y') + (addby * 9))
	
	triggerEvent('Camera Follow Pos',1400,30)
		
	setProperty('introSoundsSuffix', '-muted')
	
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think
	if counter == 0 then
		doTweenAlpha('overlaytween', 'alphabot', 0, 1, 'linear')
	elseif counter == 1 then
		addAnimationByPrefix('introsc', 'introscAnimation', 'idle', 14, false)
		objectPlayAnimation('introsc','introscAnimation',true);
		doTweenAlpha('flickTween', 'flicker', 0, 1.7, 'linear')
		
		local addby = -600
	
		if downscroll then
			addby = 600
		end
		fakeHealthBar.moveHPbar(0, addby)
	end
end



swapTable = {
	[369] = 369, --egg
	[640] = 640,
	[688] = 688, --egg
	[707] = 704,
	[866] = 866, --egg
	[1152] = 1152,
	[1394] = 1392, --egg
	[1412] = 1408,
	[1528] = 1528, --egg
	[1664] = 1660,
	[1682] = 1682, --egg
	[1696] = 1696,
	[1702] = 1702, --egg
	[1706] = 1706,
	[1710] = 1710, --egg
	[1793] = 1793,
	[1809] = 1809, --egg
	[1824] = 1824,
	[1840] = 1840, --egg
	[1856] = 1856,
	[1920] = 1920, --egg
	[1984] = 1984,
	[2001] = 2001, --egg
	[2020] = 2020, 
	[2048] = 2048, --egg
	[2054] = 2054,
}

local eggingcam = false
local imlazyrn = 0
local function swapNoteSide(printthisplease)
	setProperty('boyfriend.flipX', not swapped)
	
	if not swapped then
		addOffset('boyfriend', 'singRIGHTmiss', 110, 190)
		addOffset('boyfriend', 'singLEFTmiss', 110, 190)
		addOffset('boyfriend', 'singDOWNmiss', 110, 190)
		addOffset('boyfriend', 'singUPmiss', 110, 190)
	else
		addOffset('boyfriend', 'singRIGHTmiss', 270, 190)
		addOffset('boyfriend', 'singLEFTmiss', 270, 190)
		addOffset('boyfriend', 'singDOWNmiss', 270, 190)
		addOffset('boyfriend', 'singUPmiss', 270, 190)
	end
	
	if imlazyrn == 0 then 
		imlazyrn = 1
		setProperty("gf.visible", true)
	end
	
	--[[
	local oldRight = animation.getByName('singRIGHT').frames;
	animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
	animation.getByName('singLEFT').frames = oldRight;]]
	
	if curStep <= 369 then
		setProperty("gf.visible", false)
		setProperty("eggenterance.visible", true)
		objectPlayAnimation('eggenterance','idleanimation',true);

	end
	
	if eggingcam == false then
		if swapped == false then

	--[[
			noteTweenX('opponentStrumTween00', 4, defaultOpponentStrumX0, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween11', 5, defaultOpponentStrumX1, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween22', 6, defaultOpponentStrumX2, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween33', 7, defaultOpponentStrumX3, 1, 'smootherStepIn')
			
			noteTweenX('PlayerStrumTween00', 0, defaultPlayerStrumX0, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween11', 1, defaultPlayerStrumX1, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween22', 2, defaultPlayerStrumX2, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween33', 3, defaultPlayerStrumX3, 1, 'smootherStepIn')--]]
						
			for i = 0, 7 do
				local key = (i % 4)
				local name = i > 3 and 'realDefaultPlayerStrum' or 'realDefaultOpponentStrum'
				
				noteTweenX('start' .. i, i, _G[name .. 'X' .. key] - 640, 1, 'sineInOut')
			end
			
			for i = 8, 11 do
				local key = (i % 4)
				local name = 'realDefaultPlayerStrum'
				
				noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')
			end
		else

			for i = 0, 7 do
				local key = (i % 4)
				local name = i > 3 and 'realDefaultPlayerStrum' or 'realDefaultOpponentStrum'

				noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')

			end

			for i = 8, 11 do
				local key = (i % 4)
				local name = 'defaultLeftStrum'
				
				noteTweenX('start' .. i, i, _G[name .. 'X' .. key] + 2000, 1, 'sineInOut')

			end
			--[[
			noteTweenX('opponentStrumTween00', 0, defaultOpponentStrumX0, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween11', 1, defaultOpponentStrumX1, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween22', 2, defaultOpponentStrumX2, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween33', 3, defaultOpponentStrumX3, 1, 'smootherStepIn')
			
			noteTweenX('PlayerStrumTween00', 4, defaultPlayerStrumX0, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween11', 5, defaultPlayerStrumX1, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween22', 6, defaultPlayerStrumX2, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween33', 7, defaultPlayerStrumX3, 1, 'smootherStepIn')--]]
		end
	else
	    for i = 0, 7 do
            local key = (i % 4)
            local name
            name = i > 3 and 'defaultMiddleStrum' or 'defaultLeftStrum'

            
			noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')

        end
		
		for i = 8, 11 do
			local key = (i % 4)
			local name = 'defaultRightStrum'
			
			noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')
		end
	end
end

local function swapNoteSideSoniced(printthisplease)
	setProperty('boyfriend.flipX', swapped)
	
	if imlazyrn == 0 then 
		imlazyrn = 1
		setProperty("gf.visible", true)
	end
	
	if swapped then
		addOffset('boyfriend', 'singRIGHTmiss', 110, 190)
		addOffset('boyfriend', 'singLEFTmiss', 110, 190)
		addOffset('boyfriend', 'singDOWNmiss', 110, 190)
		addOffset('boyfriend', 'singUPmiss', 110, 190)
	else
		addOffset('boyfriend', 'singRIGHTmiss', 270, 190)
		addOffset('boyfriend', 'singLEFTmiss', 270, 190)
		addOffset('boyfriend', 'singDOWNmiss', 270, 190)
		addOffset('boyfriend', 'singUPmiss', 270, 190)
	end
	
	if curStep <= 369 then
		setProperty("gf.visible", false)
		setProperty("eggenterance.visible", true)
		setProperty('defaultCamZoom',0.5)
		objectPlayAnimation('eggenterance','idleanimation',true);

	end
	
	if eggingcam == false then
		if swapped == false then

	--[[
			noteTweenX('opponentStrumTween00', 4, defaultOpponentStrumX0, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween11', 5, defaultOpponentStrumX1, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween22', 6, defaultOpponentStrumX2, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween33', 7, defaultOpponentStrumX3, 1, 'smootherStepIn')
			
			noteTweenX('PlayerStrumTween00', 0, defaultPlayerStrumX0, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween11', 1, defaultPlayerStrumX1, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween22', 2, defaultPlayerStrumX2, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween33', 3, defaultPlayerStrumX3, 1, 'smootherStepIn')--]]
						
			for i = 0, 7 do
				local key = (i % 4)
				local name = i > 3 and 'realDefaultOpponentStrum' or 'realDefaultPlayerStrum'
				
				noteTweenX('start' .. i, i, _G[name .. 'X' .. key] + 640, 1, 'sineInOut')
			end
			
			for i = 8, 11 do
				local key = (i % 4)
				local name = 'realDefaultOpponentStrum'
				
				noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')
			end
		else

			for i = 0, 7 do
				local key = (i % 4)
				local name = i > 3 and 'realDefaultOpponentStrum' or 'realDefaultPlayerStrum'

				noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')

			end

			for i = 8, 11 do
				local key = (i % 4)
				local name = 'defaultLeftStrum'
				
				noteTweenX('start' .. i, i, _G[name .. 'X' .. key] - 700, 1, 'sineInOut')

			end
			--[[
			noteTweenX('opponentStrumTween00', 0, defaultOpponentStrumX0, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween11', 1, defaultOpponentStrumX1, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween22', 2, defaultOpponentStrumX2, 1, 'smootherStepIn')
			noteTweenX('opponentStrumTween33', 3, defaultOpponentStrumX3, 1, 'smootherStepIn')
			
			noteTweenX('PlayerStrumTween00', 4, defaultPlayerStrumX0, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween11', 5, defaultPlayerStrumX1, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween22', 6, defaultPlayerStrumX2, 1, 'smootherStepIn')
			noteTweenX('PlayerStrumTween33', 7, defaultPlayerStrumX3, 1, 'smootherStepIn')--]]
		end
	else
	    for i = 0, 7 do
            local key = (i % 4)
            local name
            name = i > 3 and 'defaultMiddleStrum' or 'defaultRightStrum'

            
			noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')

        end
		
		for i = 8, 11 do
			local key = (i % 4)
			local name = 'defaultLeftStrum'
			
			noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 1, 'sineInOut')
		end
	end
end

function onEvent(name,value1,value2)
	if name == "eggCam" then
		eggingcam = not eggingcam
	end
end

local camDisabled = true

function onBeatHit()
	if stopit == false then
		fakeHealthBar.IconBounce()
	end
end

local sonicSwapped = false

function onStepHit()
	if curStep == 5 then
		triggerEvent('Camera Follow Pos',1400,1300)
		setProperty('defaultCamZoom',0.2)

	elseif curStep == 65 then

		setProperty("dad.visible", true)
		setProperty("idlesonic.visible", false)

		noteTweenY('opponentStrumTween0', 0, defaultOpponentStrumY0, 1, 'sineInOut')
		noteTweenY('opponentStrumTween1', 1, defaultOpponentStrumY1, 1, 'sineInOut')
		noteTweenY('opponentStrumTween2', 2, defaultOpponentStrumY2, 1, 'sineInOut')
		noteTweenY('opponentStrumTween3', 3, defaultOpponentStrumY3, 1, 'sineInOut')
		
		noteTweenY('PlayerStrumTween0', 4, defaultPlayerStrumY0, 1, 'sineInOut')
		noteTweenY('PlayerStrumTween1', 5, defaultPlayerStrumY1, 1, 'sineInOut')
		noteTweenY('PlayerStrumTween2', 6, defaultPlayerStrumY2, 1, 'sineInOut')
		noteTweenY('PlayerStrumTween3', 7, defaultPlayerStrumY3, 1, 'sineInOut')
		
		fakeHealthBar.tweenDefault(1, 'sineInOut')
		
		local addby = 200
		if downscroll then
			addby = -200
		end
		
		doTweenY('timeBarBG', 'timeBarBG', getProperty('timeBarBG.y') + addby, 1, 'sineInOut')
		doTweenY('timeBar', 'timeBar', getProperty('timeBar.y') + addby, 1, 'sineInOut')
		doTweenY('timeTxt', 'timeTxt', getProperty('timeTxt.y') + addby, 1, 'sineInOut')
		doTweenY('scoreTxt', 'scoreTxt', getProperty('scoreTxt.y') - (addby * 9), 1, 'sineInOut')

	elseif curStep == 128 then
		camDisabled = false

	elseif swapTable[curStep] then
		if not sonicSwapped then 
			fakeHealthBar.swapSide()
			swapNoteSide()

		else
			fakeHealthBar.swapSideSoniced()
			swapNoteSideSoniced()

		end
		if swapped == false then
			swapped = true
			firstHealth = getHealth()
			setHealth(secondHealth)
		else
			swapped = false
			secondHealth = getHealth()
			setHealth(firstHealth)
		end
	elseif curStep == 350 then
		camDisabled = true
	elseif curStep == 367 then
		triggerEvent('Camera Follow Pos',2720,780)

	elseif curStep == 384 then
		setProperty("gf.visible", true)
		setProperty("eggenterance.visible", false)
		camDisabled = false
	elseif curStep == 617 then --616
		setProperty("dad.visible", false)
		
		camDisabled = true
		setProperty('defaultCamZoom',0.47)

		makeAnimatedLuaSprite('jumping', 'extra/sonicjump', 720,-90);
		setLuaSpriteScrollFactor('jumping', 1, 1);
		addLuaSprite('jumping', true);
		setObjectOrder('jumping', 0)
		addAnimationByPrefix('jumping', 'idleanimation', 'idle', 50, false)
		objectPlayAnimation('jumping','idleanimation',true);
		scaleObject('jumping', 10, 10);
		setObjectOrder('jumping', 6)
		setProperty('jumping.antialiasing', false);
		
		--doTweenX('jumptween', 'jumping', 800, .2, 'linear'); 
		doTweenY('jumptweenY', 'jumping', 80, .2, 'linear'); 
	elseif curStep == 623 then
		triggerEvent('Camera Follow Pos',2380,1000)
		setProperty("jumping.visible", false)

	elseif curStep == 632 then
	
		makeAnimatedLuaSprite('damaged', 'extra/eggmandamage', 1900,270);
		setLuaSpriteScrollFactor('damaged', 1, 1);
		addLuaSprite('damaged', true);
		setObjectOrder('damaged', 0)
		addAnimationByPrefix('damaged', 'idleanimation', 'idle', 24, true)
		objectPlayAnimation('damaged','idleanimation',true);
		scaleObject('damaged', 10, 10);
		setObjectOrder('damaged', 6)
		setProperty('damaged.antialiasing', false);
		
		makeAnimatedLuaSprite('jumpfall', 'extra/sonicjumpfall', 2550,-180);
		setLuaSpriteScrollFactor('jumpfall', 1, 1);
		addLuaSprite('jumpfall', true);
		setObjectOrder('jumpfall', 0)
		addAnimationByPrefix('jumpfall', 'idleanimation', 'idle', 40, false)
		objectPlayAnimation('jumpfall','idleanimation',true);
		scaleObject('jumpfall', 10, 10);
		setObjectOrder('jumpfall', 6)
		setProperty('jumpfall.antialiasing', false);
		
		doTweenX('damagetween', 'damaged', 4000, .8, 'linear'); 
		setProperty("gf.visible", false)

		setProperty('gf.x', 700)


		for i = 0, 7 do
			local key = (i % 4)
			local name = i > 3 and 'realDefaultOpponentStrum' or 'realDefaultPlayerStrum'

			noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 0.01, 'sineInOut')
		end

		for i = 8, 11 do
			local key = (i % 4)
			local name = 'defaultLeftStrum'
	
			noteTweenX('start' .. i, i, _G[name .. 'X' .. key] - 700, 0.01, 'sineInOut')
		end	
		
	elseif curStep == 639 then
		setProperty('dad.x', 2600)
		setProperty('dad.y', 1380)
		setProperty('dad.flipX', true)
		
		setProperty('gf.flipX', true)
		sonicSwapped = true

		setProperty("dad.visible", true)
		setProperty("gf.visible", true)

		setProperty("jumpfall.visible", false)
	elseif curStep == 642 then
		camDisabled = false
	elseif curStep == 770 then
		camDisabled = true
		doTweenZoom("yay", "camGame", 0.5, 7, "linear")
	elseif curStep == 864 then
		setProperty("gf.visible", false)

		triggerEvent('Camera Follow Pos',1450,1000)
		setProperty('defaultCamZoom',0.45)


		makeAnimatedLuaSprite('passed', 'extra/eggmanpassed', 160,330);
		setLuaSpriteScrollFactor('passed', 1, 1);
		addLuaSprite('passed', true);
		setObjectOrder('passed', 0)
		addAnimationByPrefix('passed', 'idleanimation', 'idle', 8, true)
		objectPlayAnimation('passed','idleanimation',false);
		scaleObject('passed', 10, 10);
		setObjectOrder('passed', 6)
		setProperty('passed.antialiasing', false);
	elseif curStep == 888 then
		camDisabled = false
		
		setProperty("gf.visible", true)
		setProperty("passed.visible", false)
		setProperty('jumping.y', -90)

	elseif curStep == 1128 then
		camDisabled = true
		setProperty("dad.visible", false)

		triggerEvent('Camera Follow Pos',1450,1200)
		setProperty('defaultCamZoom',0.55)

		setProperty("jumping.visible", true)

		setProperty('jumping.x', 2600)
		objectPlayAnimation('jumping','idleanimation',true);
		doTweenY('jumptweenY', 'jumping', 140, .7, 'linear'); 

	elseif curStep == 1143 then
		setProperty("gf.visible", false)

		setProperty("jumping.visible", false)
		setProperty("jumpfall.visible", true)
		setProperty('jumpfall.x', 700)
		objectPlayAnimation('jumpfall','idleanimation',true);
				
		setProperty("damaged.visible", true)
		setProperty('damaged.flipX', true)
		
		setProperty('damaged.flipX', true)
		setProperty('damaged.x', 420)
		
		doTweenX('damagetween', 'damaged', -2000, .8, 'linear'); 

		sonicSwapped = false

		for i = 0, 7 do
			local key = (i % 4)
			local name = i > 3 and 'realDefaultPlayerStrum' or 'realDefaultOpponentStrum'

			noteTweenX('start' .. i, i, _G[name .. 'X' .. key], 0.01, 'sineInOut')
		end

		for i = 8, 11 do
			local key = (i % 4)
			local name = 'defaultRightStrum'
	
			noteTweenX('start' .. i, i, _G[name .. 'X' .. key] - 700, 0.01, 'sineInOut')
		end	

	elseif curStep == 1149 then
		setProperty("jumpfall.visible", false)

		setProperty('dad.x', 790)
		setProperty('dad.y', 1360)
		setProperty('dad.flipX', false)
		
		setProperty('gf.flipX', false)
		setProperty('gf.x', 2440)

		setProperty("dad.visible", true)
	elseif curStep == 1156 then
		camDisabled = false
	elseif curStep == 1344 then
		triggerEvent('Camera Follow Pos',1400,1300)
		setProperty('defaultCamZoom',0.6 + zoomadd)
		camDisabled = true
	elseif curStep == 1393 then
		camDisabled = false
		setProperty("gf.visible", true)
	elseif curStep == 2248 then
		camDisabled = true
		setProperty("gf.visible", false)

		triggerEvent('Camera Follow Pos',2380,1000)

		makeAnimatedLuaSprite('deathBack', 'extra/deathBack', 1950,320);
		setLuaSpriteScrollFactor('deathBack', 1, 1);
		addLuaSprite('deathBack', true);
		setObjectOrder('deathBack', 0)
		addAnimationByPrefix('deathBack', 'idleanimation', 'idle', 50, false)
		objectPlayAnimation('deathBack','idleanimation',true);
		scaleObject('deathBack', 10, 10);
		setObjectOrder('deathBack', 6)
		setProperty('deathBack.antialiasing', false);
		
		doTweenX('damagetween', 'deathBack', 2200, 1, 'linear'); 

	elseif curStep == 2270 then
		triggerEvent('Camera Follow Pos',1300,1250)
		setProperty('defaultCamZoom',0.5)

	elseif curStep == 2296 then
		
		--triggerEvent('Camera Follow Pos',1300,1300)
		stopit = true

		makeAnimatedLuaSprite('deathAttack', 'extra/deathAttack', -1150,650);
		setLuaSpriteScrollFactor('deathAttack', 1, 1);
		addLuaSprite('deathAttack', true);
		setObjectOrder('deathAttack', 0)
		addAnimationByPrefix('deathAttack', 'idleanimation', 'idle', 40, false)
		objectPlayAnimation('deathAttack','idleanimation',true);
		scaleObject('deathAttack', 10, 10);
		setObjectOrder('deathAttack', 6)
		setProperty('deathAttack.antialiasing', false);

	elseif curStep == 2300 then
	
		setProperty("dad.visible", false)


		makeAnimatedLuaSprite('sonicdead', 'extra/deathSonic', 690,700);
		setLuaSpriteScrollFactor('sonicdead', 1, 1);
		addLuaSprite('sonicdead', true);
		setObjectOrder('sonicdead', 0)
		addAnimationByPrefix('sonicdead', 'idleanimation', 'idle', 35, false)
		objectPlayAnimation('sonicdead','idleanimation',true);
		scaleObject('sonicdead', 10, 10);
		setObjectOrder('sonicdead', 7)
		setProperty('sonicdead.antialiasing', false);
		
		--setProperty('boyfriend.animation.curAnim.curFrame', getProperty('boyfriend.animation.curAnim.curFrame'))
		--setProperty('waterfall.animation.curAnim.curFrame', getProperty('waterfall.animation.curAnim.curFrame'))
		setProperty('boyfriend.animation.curAnim.paused', true)
		setProperty('waterfall.animation.curAnim.paused', true)
	elseif curStep == 2335 then
		doTweenAlpha('overlaytween', 'alphabot', 1, 1, 'linear')

	elseif curStep == 2340 then
		setProperty('alphabot.alpha', 1)
		doTweenAlpha('flickTween', 'flicker', 1, 1, 'linear')

	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if getProperty('boyfriend.flipX') then
		if direction == 0 then
			playAnim('boyfriend', 'sing' .. directions[4], true, false, 0)
			setProperty("boyfriend.holdTimer", 0)
		elseif direction == 3 then
			playAnim('boyfriend', 'sing' .. directions[1], true, false, 0)
			setProperty("boyfriend.holdTimer", 0)
		end
	end
	
	for i = 0, getProperty('grpNoteSplashes.length') - 1 do
		setPropertyFromGroup('grpNoteSplashes', i, 'animation.curAnim.frameRate', 14)
		setPropertyFromGroup('grpNoteSplashes', i, 'offset.x', 20)
		setPropertyFromGroup('grpNoteSplashes', i, 'offset.y', 0)

	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if sonicSwapped then
		if direction == 0 then
			if gfSection then
				playAnim('gf', 'sing' .. directions[4], true, false, 0)
				setProperty("gf.holdTimer", 0)
			else
				playAnim('dad', 'sing' .. directions[4], true, false, 0)
				setProperty("dad.holdTimer", 0)
			end
		elseif direction == 3 then
			if gfSection then
				playAnim('gf', 'sing' .. directions[1], true, false, 0)
				setProperty("gf.holdTimer", 0)
			else
				playAnim('dad', 'sing' .. directions[1], true, false, 0)
				setProperty("dad.holdTimer", 0)
			end
		end
	end
end


function onUpdate(elapsed)---[[
	if stopit == false then
		fakeHealthBar.progressBar()
		if camDisabled == false then
			if sonicSwapped == false then
				if gfSection then--eggman
					triggerEvent('Camera Follow Pos',2380,1000)
					setProperty('defaultCamZoom',0.45 + zoomadd)
				elseif eggingcam then --both
					triggerEvent('Camera Follow Pos',1750,1000)
					setProperty('defaultCamZoom',0.45 + zoomadd)
				elseif mustHitSection then --bf
					triggerEvent('Camera Follow Pos',1650,1350)
					--setProperty('defaultCamZoom',0.56)
				else --sonic
					triggerEvent('Camera Follow Pos',1450,1300)
					setProperty('defaultCamZoom',0.47 + zoomadd)
				end
			else
				if gfSection then --eggman
					triggerEvent('Camera Follow Pos',1450,1000)
					setProperty('defaultCamZoom',0.45 + zoomadd)
				elseif eggingcam then --both
					triggerEvent('Camera Follow Pos',1750,1000)
					setProperty('defaultCamZoom',0.45 + zoomadd)
				elseif mustHitSection then --bf
					triggerEvent('Camera Follow Pos',1650,1350)
					--setProperty('defaultCamZoom',0.56)
				else --sonic
					triggerEvent('Camera Follow Pos',2380,1300)
					setProperty('defaultCamZoom',0.47 + zoomadd)
				end
			end
		end
	else
		setProperty('boyfriend.animation.curAnim.paused', true)
	end
	overlayChange(math.floor(getProperty('alphabot.alpha') * 10))
end