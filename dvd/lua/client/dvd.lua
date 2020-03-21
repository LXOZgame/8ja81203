local screenW,screenH = guiGetScreenSize()

local dvdEnabled = false
local dvdImageTexture = dxCreateTexture("materials/png/dvd.png","argb",true,"clamp")
local dvdImageX,dvdImageY = 0.250,0.250
local dvdImageW,dvdImageH = 0.150,0.150
local dvdNewX,dvdNewY = 0.800,0.800

local dvdXSpeed = 0.0025
local dvdYSpeed = 0.005

local dvdXMoving = true
local dvdYMoving = true

local r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)

function dvdRender ()
	if dvdXMoving then
		dvdImageX = dvdImageX + dvdXSpeed
	else
		dvdImageX = dvdImageX - dvdXSpeed	
	end
	if dvdYMoving then
		dvdImageY = dvdImageY + dvdYSpeed
	else
		dvdImageY = dvdImageY - dvdYSpeed
	end	
	if dvdImageX > 0.850 then
		dvdXMoving = false
		r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
	end
	if dvdImageY > 0.850 then
		dvdYMoving = false
		r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
	end
	if dvdImageX < 0.000 then
		dvdXMoving = true
		r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
	end
	if dvdImageY < 0.000 then
		dvdYMoving = true
		r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
	end
	dxDrawImage(screenW*dvdImageX,screenH*dvdImageY,screenW*dvdImageW,screenH*dvdImageH,dvdImageTexture,0,0,0,tocolor(r,g,b,255))
end

addCommandHandler("dvd",function()
	dvdEnabled = not dvdEnabled
	showChat(not dvdEnabled)
	fadeCamera(not dvdEnabled)
	if dvdEnabled then
		addEventHandler("onClientRender",root,dvdRender)
	else
		removeEventHandler("onClientRender",root,dvdRender)
	end
end)