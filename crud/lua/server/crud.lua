local connection = dbConnect("mysql","dbname=lxoz;host=127.0.0.1","root","","share=1")

addEvent("addNewUserInDataBase",true)
addEventHandler("addNewUserInDataBase",root,function(firstname,surname,adress)
	if connection then
		if adress == nil then
			adress = "not"
		end
		dbExec(connection,"INSERT INTO users (num,firstname,surname,adress) VALUES (?,?,?,?)",math.random(1,1000000),firstname,surname,adress)
		triggerEvent("refreshUsersTableDataBase",source,true)
	end
end)

addEvent("removeUserInDataBase",true)
addEventHandler("removeUserInDataBase",root,function(keyNumber)
	if connection then
		local selectedConnection = dbQuery(connection,"SELECT * FROM users")
		local result,numberRows = dbPoll(selectedConnection,-1)
		for key,value in next,result do
			for key2,value2 in next,value do
				if key2 == "num" then
					if keyNumber == value2 then
						dbExec(connection,"DELETE FROM users WHERE num=?",value2)
						triggerEvent("refreshUsersTableDataBase",source,true)
						return false
					end	
				end	
			end
		end
	end
end)

function refreshUsersTableDataBase (all)
	if connection then
		local selectedConnection = dbQuery(connection,"SELECT * FROM users")
		local result,numberRows = dbPoll(selectedConnection,-1)
		if all then
			triggerClientEvent("refreshUsersTableDataBaseClient",source,result)
		else
			triggerClientEvent(source,"refreshUsersTableDataBaseClient",source,result)
		end
	end	
end
addEvent("refreshUsersTableDataBase",true)
addEventHandler("refreshUsersTableDataBase",root,refreshUsersTableDataBase)