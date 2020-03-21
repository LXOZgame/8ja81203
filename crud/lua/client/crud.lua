local screenW,screenH = guiGetScreenSize()
local screenScale = screenW + screenH

local crudEnabled = false
local crudMenuEnabled = true

local usersTable = {}

addEvent("refreshUsersTableDataBaseClient",true)
addEventHandler("refreshUsersTableDataBaseClient",root,function(t)
	if crudEnabled then
		usersTable = t
	end	
end)

local usersListOffSet = 0
local enteredNameUsersList = false
local selectedNameUsersList = false

local deleteUser = false

function crudRender ()
	dxDrawImage(screenW*0.000,screenH*0.000,screenW*1.000,screenH*1.000,"materials/jpg/fon.jpg")
	dxDrawRectangle(screenW*0.000,screenH*0.000,screenW*1.000,screenH*1.000,tocolor(0,0,0,100))
	dxDrawText("CRUD",screenW*0.000,screenH*0.075,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00087,"default","center")
	if crudMenuEnabled then
		dxDrawText("Добавление нового пользователя",screenW*0.000,screenH*0.775,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00087,"default","center")	
		dxDrawText("Имя пользователя:",screenW*0.425,screenH*0.275,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00047,"default")
		dxDrawText("Фамилия пользователя:",screenW*0.400,screenH*0.375,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00047,"default")
		dxDrawText("Адрес проживания:",screenW*0.3875,screenH*0.475,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00047,"default")
		createEdit("1",screenW*0.425,screenH*0.300,screenW*0.150,screenH*0.050,tocolor(255,255,255,150),20)
		createEdit("2",screenW*0.400,screenH*0.400,screenW*0.200,screenH*0.050,tocolor(255,255,255,125),30)
		createEdit("3",screenW*0.3875,screenH*0.500,screenW*0.225,screenH*0.050,tocolor(255,255,255,125),30)
		createButton("add","Добавить",screenW*0.300,screenH*0.650,screenH*0.050,tocolor(0,0,0,100))
	else
		dxDrawText("Редактирование пользователей",screenW*0.000,screenH*0.775,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00087,"default","center")
		dxDrawText("Общий список пользователей:",screenW*0.000,screenH*0.225,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00047,"default","center")
		dxDrawRectangle(screenW*0.350,screenH*0.250,screenW*0.300,screenH*0.5125,tocolor(0,0,0,100))
		enteredNameUsersList = false
		for key,value in next,usersTable do
			if usersListOffSet + 20 >= key  and usersListOffSet <= key - 1 then
				local text = ""
				local num = ""
				for key2,value2 in next,value do
					if key2 == "num" then
						num = value2
					elseif key2 == "firstname" then
						text = text..value2
					elseif key2 == "surname" then
						text = text.." "..value2
					elseif key2 == "adress" then
						dxDrawText("Адрес: "..value2,screenW*0.6425,screenH*(0.260 + ((key-1) * 0.025) - (usersListOffSet * 0.025)),screenW*0.6425,screenH,tocolor(255,255,255,200),screenScale*0.00047,"default","right")
					end		
				end	
				if isCursorInPosition(screenW*0.3575,screenH*(0.260 + ((key-1) * 0.025) - (usersListOffSet * 0.025)),screenW*0.285,screenH*0.025) then
					enteredNameUsersList = num
					dxDrawText(text,screenW*0.3575,screenH*(0.260 + ((key-1) * 0.025) - (usersListOffSet * 0.025)),screenW,screenH,tocolor(255,255,255,255),screenScale*0.00047,"default")
				else
					if selectedNameUsersList == num then
						dxDrawText(text,screenW*0.3575,screenH*(0.260 + ((key-1) * 0.025) - (usersListOffSet * 0.025)),screenW,screenH,tocolor(255,255,255,255),screenScale*0.00047,"default")
					else
						dxDrawText(text,screenW*0.3575,screenH*(0.260 + ((key-1) * 0.025) - (usersListOffSet * 0.025)),screenW,screenH,tocolor(255,255,255,200),screenScale*0.00047,"default")
					end
				end
			end	
		end	
		if selectedNameUsersList then
			if deleteUser then
				dxDrawText("Вы точно уверены?",screenW*0.200,screenH*0.575,screenW,screenH,tocolor(255,255,255,255),screenScale*0.00047,"default")
				createButton("removeUserYes","Да",screenW*0.225,screenH*0.600,screenH*0.050,tocolor(0,0,0,100))
				createButton("removeUserNo","Нет",screenW*0.275,screenH*0.600,screenH*0.050,tocolor(0,0,0,100))
			else
				createButton("removeUser","Удалить пользователя",screenW*0.225,screenH*0.600,screenH*0.050,tocolor(0,0,0,100))
			end
		end
	end	
	createButton("next","Далее",screenW*0.350,screenH*0.825,screenH*0.050,tocolor(0,0,0,100))
end

bindKey("mouse_wheel_up","down",function()
	if crudEnabled then
		if isCursorInPosition(screenW*0.350,screenH*0.250,screenW*0.300,screenH*0.5125) and usersListOffSet > 0 then
			usersListOffSet = usersListOffSet - 1
		end
	end
end)

bindKey("mouse_wheel_down","down",function()
	if crudEnabled then
		if isCursorInPosition(screenW*0.350,screenH*0.250,screenW*0.300,screenH*0.5125) and usersListOffSet < #usersTable - 20 then
			usersListOffSet = usersListOffSet + 1
		end
	end
end)

function createWindow1 (x,y,w,h,color)
	dxDrawRectangle(x,y,w,h,color)
	dxDrawCircle(x,y + (h/2),h/2,90,270,color)
	dxDrawCircle(x + w,y + (h/2),h/2,270,450,color)
end

local edit = {}
edit["entered"] = false
edit["selected"] = false

function createEdit (name,x,y,w,h,color,maxSymbols)
	createWindow1(x,y,w,h,color)
	if isCursorInPosition(x,y,w,h) then
		edit["entered"] = name
	end
	local text = ""
	if edit["selected"] == name then
		if edit["text"..name] then
			for key,value in next,edit["text"..name] do
				text = text..value
			end
		else
			edit["text"..name] = {}
		end
		if not edit["maxSymbols"..name] then
			edit["maxSymbols"..name] = maxSymbols
		end	
		createWindow1(x,y,w,h,tocolor(0,0,0,25))
		dxDrawText(text,x,y + (h/3.5),w,h,tocolor(0,0,0,255),screenScale*0.00047,"default")
		dxDrawText("|",x + dxGetTextWidth(text,screenScale*0.00047,"default"),y + (h/3.5),w,h,tocolor(0,0,0,255),screenScale*0.00047,"default")
	else
		if edit["text"..name] then
			if #edit["text"..name] >= 1 then
				for key,value in next,edit["text"..name] do
					text = text..value
				end
			end
		end	
		dxDrawText(text,x,y + (h/3.5),w,h,tocolor(0,0,0,255),screenScale*0.00047,"default")
	end
end

function getEditText (name)
	local text = ""
	if edit["text"..name] then
		if #edit["text"..name] >= 1 then
			for key,value in next,edit["text"..name] do
				text = text..value
			end
		end
	end	
	return text
end

local button = {}
button["entered"] = false

local buttonCheck = false

function createButton (name,text,x,y,h,color)
	local w = dxGetTextWidth(text,screenScale*0.00047,"default")
	createWindow1(x,y,w,h,color)
	if isCursorInPosition(x,y,w,h) then
		buttonCheck = true
		button["entered"..name] = true
		createWindow1(x,y,w,h,tocolor(255,255,255,25))
	else
		button["entered"..name] = false
	end
	dxDrawText(text,x,y + (h/3.5),w,h,tocolor(255,255,255,255),screenScale*0.00047,"default")
end

addEventHandler("onClientCharacter",root,function(character)
	if crudEnabled then
		if edit["selected"] then
			if #edit["text"..edit["selected"]] < edit["maxSymbols"..edit["selected"]] then
				table.insert(edit["text"..edit["selected"]],character)
			end	
		end
	end
end)

bindKey("backspace","down",function()
	if crudEnabled then
		if edit["selected"] then
			table.remove(edit["text"..edit["selected"]],#edit["text"..edit["selected"]])
			if isTimer(backspaceTimer) then
				killTimer(backspaceTimer)
			end
			backspaceTimer = setTimer(function()
				function backspaceRender ()
					if getKeyState("backspace") then
						table.remove(edit["text"..edit["selected"]],#edit["text"..edit["selected"]])
					else
						removeEventHandler("onClientRender",root,backspaceRender)
					end
				end
				addEventHandler("onClientRender",root,backspaceRender)
			end,500,1)
		end
	end	
end)

bindKey("mouse1","down",function()
	if crudEnabled then
		if edit["entered"] then
			edit["selected"] = edit["entered"]
		end
		if button["enteredadd"] then
			local firstname = getEditText("1")
			local surname = getEditText("2")
			local adress = getEditText("3")
			if string.len(firstname) >= 4 and string.len(surname) >= 4 then
				if string.len(adress) == 0 then
					adress = nil
				end
				triggerServerEvent("addNewUserInDataBase",localPlayer,firstname,surname,adress)
			end	
		elseif button["enterednext"] then
			crudMenuEnabled = not crudMenuEnabled
			button["enterednext"] = false
		elseif button["enteredremoveUser"] then
			deleteUser = true
			button["enteredremoveUser"] = false
		elseif button["enteredremoveUserYes"] then	
			if selectedNameUsersList then
				triggerServerEvent("removeUserInDataBase",localPlayer,selectedNameUsersList)
				deleteUser = false
				selectedNameUsersList = false
				button["enteredremoveUserYes"] = false
			end	
		elseif button["enteredremoveUserNo"] then	
			deleteUser = false
			button["enteredremoveUserNo"] = false
		end
		if enteredNameUsersList then
			selectedNameUsersList = enteredNameUsersList
		else
			if not buttonCheck then
				selectedNameUsersList = false
			else
				buttonCheck = false
			end	
		end
	end	
end)

addCommandHandler("crud",function()
	crudEnabled = not crudEnabled
	showCursor(crudEnabled)
	showChat(not crudEnabled)
	if crudEnabled then
		triggerServerEvent("refreshUsersTableDataBase",localPlayer,false)
		addEventHandler("onClientRender",root,crudRender)
	else
		removeEventHandler("onClientRender",root,crudRender)
	end
end)

function isCursorInPosition (x,y,w,h)
	if isCursorShowing()then
        local screenX,screenY = guiGetScreenSize()
        local cursorX,cursorY = getCursorPosition()
        if screenX*cursorX >= x and screenX*cursorX <= x + w and screenY*cursorY >= y and screenY*cursorY <= y + h then
            return true
        else
            return false
        end
    end    
end