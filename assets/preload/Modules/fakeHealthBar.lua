local coolModule = {}

local healthbarX = 411
local healthbarY = 725

local paused = false

local bfIcon
local dadIcon
local themath

function setObjectClip(spr, x, y, width, height) --function written by raltyro#1324
    -- Check and Fix Arguments
    if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
    x = type(x) == "number" and x or getProperty(spr .. ".frame.frame.x")
    y = type(y) == "number" and y or getProperty(spr .. ".frame.frame.y")
    width = type(width) == "number" and width >= 0 and width or getProperty(spr .. ".frame.frame.width")
    height = type(height) == "number" and height >= 0 and height or getProperty(spr .. ".frame.frame.height")
    
    -- ClipRect
    setProperty(spr .. "._frame.frame.x", x)
    setProperty(spr .. "._frame.frame.y", y)
    setProperty(spr .. "._frame.frame.width", width)
    setProperty(spr .. "._frame.frame.height", height)
    
    return x, y, width, height
end

local function createHPIcon(who, color)

	local whoIcon = 'icons/icon-'..who;


	local fuckpussyshit = 'icon'..who
	makeLuaSprite(fuckpussyshit, whoIcon,0, healthbarY);
	setScrollFactor(fuckpussyshit,0, 0);
	scaleObject(fuckpussyshit, 4, 4);

	--setProperty('tbOuter.alpha', 0)
	setObjectClip(fuckpussyshit, nil, nil, getProperty(fuckpussyshit .. ".frame.frame.width") / 2, getProperty(fuckpussyshit .. ".frame.frame.height"))
	screenCenter(fuckpussyshit, 'x')
	addLuaSprite(fuckpussyshit, false);
	setProperty(fuckpussyshit..'.antialiasing', false);
	setObjectCamera(fuckpussyshit, 'hud')
	setObjectOrder(fuckpussyshit, 15)
	updateHitbox(fuckpussyshit)
	return {fuckpussyshit, color}
end

coolModule.Init = function() --start the whole thing
	
	healthbarY= screenHeight * 0.89
	if downscroll then healthbarY = 0.11 * screenHeight end
	themath = 1
	
	setProperty('healthBar.visible', false)
	setProperty('healthBarBG.visible', false)
	setProperty('iconP1.visible', false)
	setProperty('iconP2.visible', false)
	
	bfIcon = createHPIcon('bfreal', '4B4A4B') --cause of the way this works the colors are swapped lol
	dadIcon = createHPIcon('burnsonic', '0FA5EB') -- cause of the way this works colors are swapped lol

	makeLuaSprite('tbOuter', 'fakeHPBarImages/hpBarFrame',0, healthbarY);
	setScrollFactor('tbOuter',0, 0);
	--setProperty('tbOuter.alpha', 0)
	screenCenter('tbOuter', 'x')
	addLuaSprite('tbOuter', false);
	setObjectCamera('tbOuter', 'hud')
	
	healthbarX = getProperty('tbOuter.x')
	

	setProperty(dadIcon[1] .. '.y', healthbarY - 40)
	setProperty(dadIcon[1] .. '.x', healthbarX - 45)
	
	setProperty(bfIcon[1] .. '.y', healthbarY - 40)
	setProperty(bfIcon[1] .. '.x', healthbarX + 640)

	--iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
	--setProperty(p1..'.y', 
	
	makeLuaSprite('hpInner', 'fakeHPBarImages/hpBarInside',5, healthbarY + 5);
	setScrollFactor('hpInner',0, 0);
	--setProperty('hpInner.alpha', 0)
	screenCenter('hpInner', 'x')
	addLuaSprite('hpInner', false);
	setObjectCamera('hpInner', 'hud')
	doTweenColor('hpInnerTween', 'hpInner', bfIcon[2], 0.5, 'linear')


	makeLuaSprite('hpInnerBF', 'fakeHPBarImages/hpBarInside',5, healthbarY + 5);
	setScrollFactor('hpInnerBF',0, 0);
	--setProperty('hpInnerBF.alpha', 0)
	screenCenter('hpInnerBF', 'x')
	addLuaSprite('hpInnerBF', false);
	setObjectCamera('hpInnerBF', 'hud')
	setObjectOrder('hpInnerBF', 4)
	doTweenColor('hpInnerBFTween', 'hpInnerBF', dadIcon[2], 0.5, 'linear')


	--scaleObject('tbOuter', 5, 5);

end

coolModule.moveHPbar = function(x, y)
	local newHealthY = healthbarY - y
	local newHealthX = healthbarX - x
	
	setProperty('tbOuter.y', newHealthY)
	setProperty('tbOuter.x', newHealthX - 0)

	setProperty('hpInner.y', newHealthY - 5)
	--setProperty('hpInner.x', newHealthX - 0)

	setProperty('hpInnerBF.y', newHealthY - 5)
	--setProperty('hpInnerBF.x', newHealthX - 0)


	setProperty(bfIcon[1] .. '.y', newHealthY - 40)
	--setProperty(bfIcon[1] .. '.x', newHealthX - 160)

	setProperty(dadIcon[1] .. '.y', newHealthY - 40)
	--setProperty(dadIcon[1] .. '.x', newHealthX + 475)
end

coolModule.tweenHPbar = function(x, y, dest, dur, ease)
	local newHealthY = healthbarY - y
	local newHealthX = healthbarX - x

	doTweenX('tbOuter', 'tbOuter', x, dur, ease)
	doTweenY('hpInner', 'hpInner', y, dur, ease)
	doTweenY('hpInnerBF', 'hpInnerBF', y, dur, ease)

end

local turnvalue = 4.5
coolModule.IconBounce = function()

	turnvalue = 4.5
	if curBeat % 2 == 0 then
	turnvalue = -4.5
	end



	setProperty(dadIcon[1]..'.angle',-turnvalue)
	setProperty(bfIcon[1]..'.angle',turnvalue)
	
	doTweenAngle('iconTween1',bfIcon[1],0,crochet/1000,'circOut')
	doTweenAngle('iconTween2',dadIcon[1],0,crochet/1000,'circOut')


	
end

coolModule.tweenDefault = function(dur, ease)

	doTweenX('tbOuter', 'tbOuter', healthbarX, dur, ease)
	doTweenY('tbOuter', 'tbOuter', healthbarY, dur, ease)

	doTweenY('hpInner', 'hpInner', healthbarY + 5, dur, ease)
	--doTweenX('hpInner', 'hpInner', healthbarX, dur, ease)

	doTweenY('hpInnerBF', 'hpInnerBF', healthbarY + 5, dur, ease)
	--doTweenX('hpInnerBF', 'hpInnerBF', healthbarX, dur, ease)
	
	doTweenY(dadIcon[1], dadIcon[1], healthbarY - 40, dur, ease)
	doTweenY(bfIcon[1], bfIcon[1], healthbarY - 40, dur, ease)

	--makeLuaSprite('hpInner', 'fakeHPBarImages/hpBarInside',0, healthbarY + 5);

end

coolModule.ChangeIcon = function(tab, im, co)
	local whoIcon = 'icons/icon-'..im;

 	loadGraphic(tab[1], whoIcon, nil, nil) 
	updateHitbox(tab[1])
	tab[2] = co

end

coolModule.ChangeBarColor = function(tab, co)
	tab[2] = co
end

local soniced = false
coolModule.swapSide = function()
	soniced = false
	if themath == 1 then --backwards
		themath = 0
		
		coolModule.ChangeIcon(dadIcon, 'egg', 'FF444E')
		coolModule.ChangeBarColor(dadIcon, 'FF444E')
		coolModule.ChangeBarColor(bfIcon, '0FA5EB')
		
		setProperty(bfIcon[1] .. '.y', healthbarY - 40)
		setProperty(bfIcon[1] .. '.x', healthbarX - 45)
	
		setProperty(dadIcon[1] .. '.y', healthbarY - 40)
		setProperty(dadIcon[1] .. '.x', healthbarX + 638)
				
		doTweenColor('hpInnerTween', 'hpInner', bfIcon[2], 0.5, 'linear')
		doTweenColor('hpInnerBFTween', 'hpInnerBF', dadIcon[2], 0.5, 'linear')

	else --normal
		themath = 1

		coolModule.ChangeIcon(dadIcon, 'burnsonic', '0FA5EB')
		coolModule.ChangeBarColor(dadIcon, '0FA5EB')
		coolModule.ChangeBarColor(bfIcon, '4B4A4B')
		
		setProperty(dadIcon[1] .. '.y', healthbarY - 40)
		setProperty(dadIcon[1] .. '.x', healthbarX - 45)
	
		setProperty(bfIcon[1] .. '.y', healthbarY - 40)
		setProperty(bfIcon[1] .. '.x', healthbarX + 640)
		
		
		doTweenColor('hpInnerTween', 'hpInner', bfIcon[2], 0.5, 'linear')
		doTweenColor('hpInnerBFTween', 'hpInnerBF', dadIcon[2], 0.5, 'linear')
	end
end

coolModule.swapSideSoniced = function()
	soniced = true
	if themath == 1 then --backwards
		themath = 0
		
		coolModule.ChangeIcon(dadIcon, 'egg', '0FA5EB')
		coolModule.ChangeBarColor(dadIcon, '0FA5EB')
		coolModule.ChangeBarColor(bfIcon, 'FF444E')
		
		setProperty(dadIcon[1] .. '.y', healthbarY - 40)
		setProperty(dadIcon[1] .. '.x', healthbarX - 55)
	
		setProperty(bfIcon[1] .. '.y', healthbarY - 40)
		setProperty(bfIcon[1] .. '.x', healthbarX + 640)
		
		
		doTweenColor('hpInnerTween', 'hpInner', bfIcon[2], 0.5, 'linear')
		doTweenColor('hpInnerBFTween', 'hpInnerBF', dadIcon[2], 0.5, 'linear')

	else --normal
		themath = 1

		coolModule.ChangeIcon(dadIcon, 'burnsonic', '4B4A4B')
		coolModule.ChangeBarColor(dadIcon, '4B4A4B')
		coolModule.ChangeBarColor(bfIcon, '0FA5EB')
		
		setProperty(bfIcon[1] .. '.y', healthbarY - 40)
		setProperty(bfIcon[1] .. '.x', healthbarX - 45)
	
		setProperty(dadIcon[1] .. '.y', healthbarY - 40)
		setProperty(dadIcon[1] .. '.x', healthbarX + 640)
				
		doTweenColor('hpInnerTween', 'hpInner', bfIcon[2], 0.5, 'linear')
		doTweenColor('hpInnerBFTween', 'hpInnerBF', dadIcon[2], 0.5, 'linear')

	end
end

local lengthTween = nil
local previousLength = nil
local lengthIncrement = nil

function Lerp(a, b, c)
    return a + ((b - a) * c)
end

local wedoSomeTesting = 0
coolModule.progressBar = function()
	if soniced == false then
		scaleObject('hpInner', themath - (getHealth() / 2), 1);
	else
		if themath == 0 then
			scaleObject('hpInner', 1 - (getHealth() / 2), 1);
		else
			scaleObject('hpInner', 0 - (getHealth() / 2), 1);
		end
	end
	if getHealth()/2 >= 0.80 then
		setObjectClip(dadIcon[1], getProperty(dadIcon[1] .. ".frame.frame.width") / 2, nil, getProperty(dadIcon[1] .. ".frame.frame.width") / 2, nil)
	elseif getHealth()/2 <= 0.79 then
		setObjectClip(dadIcon[1], nil, nil, getProperty(dadIcon[1] .. ".frame.frame.width") / 2, nil)
	end
	if getHealth()/2 <= 0.20 then
		setObjectClip(bfIcon[1], getProperty(bfIcon[1] .. ".frame.frame.width") / 2, nil, getProperty(bfIcon[1] .. ".frame.frame.width") / 2, nil)
	else
		setObjectClip(bfIcon[1], nil, nil, getProperty(bfIcon[1] .. ".frame.frame.width") / 2, nil)
	end
end

return coolModule