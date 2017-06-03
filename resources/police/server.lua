if(db.driver == "mysql") then
	require "resources/essentialmode/lib/MySQL"
	MySQL:open(db.sql_host, sql_database, sql_user, sql_password)
elseif(db.driver == "mysql-async") then
	require "resources/mysql-async/lib/MySQL"
end

local inServiceCops = {}

function addCop(identifier)
	
	if(db.driver == "mysql") then
		local result = "nil"
		local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
		local resultq = MySQL:getResults(query, {'rank'}, "identifier")
		
		if(not resultq[1]) then
			result = "nil"
		else
			result = resultq[1].rank
		end
		
		if(result == "nil") then
			MySQL:executeQuery("INSERT INTO police (`identifier`) VALUES ('')", { ['@identifier'] = identifier})
		end
		
	elseif(db.driver == "mysql-async") then
		MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
			if(result[1] == nil) then
				MySQL.Async.execute("INSERT INTO police (`identifier`) VALUES ('"..identifier.."')", { ['@identifier'] = identifier})
			end
		end)
	end
end

function remCop(identifier)
	if(db.driver == "mysql") then
		MySQL:executeQuery("DELETE FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	elseif(db.driver == "mysql-async") then
		MySQL.Async.execute("DELETE FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier})
	end
end

function checkIsCop(identifier)
	if(db.driver == "mysql") then
		local query = MySQL:executeQuery("SELECT * FROM police WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
		local result = MySQL:getResults(query, {'rank'}, "identifier")
		
		if(not result[1]) then
			TriggerClientEvent('police:receiveIsCop', source, "unknown")
		else
			TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
		end
	elseif(db.driver == "mysql-async") then
		MySQL.Async.fetchAll("SELECT * FROM police WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
			if(result[1] == nil) then
				TriggerClientEvent('police:receiveIsCop', source, "unknown")
			else
				TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
			end
		end)
	end
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		if(config.useJobSystem == true) then
			TriggerEvent("jobssystem:disconnectReset", source, config.job.officer_not_on_duty_job_id)
		end
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

if(config.useCopWhitelist == true) then
	RegisterServerEvent('police:checkIsCop')
	AddEventHandler('police:checkIsCop', function()
		local identifier = getPlayerID(source)
		checkIsCop(identifier)
	end)
end

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()

	if(not inServiceCops[source]) then
		inServiceCops[source] = GetPlayerName(source)
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()

	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:getAllCopsInService')
AddEventHandler('police:getAllCopsInService', function()
	TriggerClientEvent("police:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate)

	if(db.driver == "mysql") then
		local executed_query = MySQL:executeQuery("SELECT username FROM user_vehicle JOIN ezwhitelist ON user_vehicle.identifier = ezwhitelist.identifier WHERE vehicle_plate = '@plate'", { ['@plate'] = plate })
		local result = MySQL:getResults(executed_query, { 'username' }, "identifier")
		if (result[1]) then
			for _, v in ipairs(result) do
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, "Le véhicule #"..plate.." appartient à " .. v.username)
			end
		else
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, "Le véhicule #"..plate.." n'est pas enregistré !")
		end
	elseif(db.driver == "mysql-async") then
		MySQL.Async.fetchAll("SELECT * FROM user_vehicle JOIN ezwhitelist ON user_vehicle.identifier = ezwhitelist.identifier WHERE vehicle_plate = '"..plate.."'", { ['@plate'] = plate }, function (result)
			if(result[1]) then
				for _, v in ipairs(result) do
					TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, "Le véhicule #"..plate.." appartient à " .. v.username)
				end
			else
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, "Le véhicule #"..plate.." n'est pas enregistré !")
			end
		end)
	end
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, GetPlayerName(t).. " est sortie !")
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:dragRequest')
AddEventHandler('police:dragRequest', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, GetPlayerName(t).. " est sortie !")
	TriggerClientEvent('police:toggleDrag', t, source)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(target)

	local identifier = getPlayerID(target)
	
	if(config.useVDKInventory == true) then
		if(db.driver == "mysql") then
			local strResult = "Items de " .. GetPlayerName(target) .. " : "
			local executed_query = MySQL:executeQuery("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '@username'", { ['@username'] = identifier })
			local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id', 'isIllegal' }, "item_id")
			if (result) then
				for _, v in ipairs(result) do
					if(v.quantity ~= 0) then
						strResult = strResult .. v.quantity .. " de " .. v.libelle .. ", "
					end
					if(v.isIllegal == "1" or v.isIllegal == "True" or v.isIllegal == 1 or v.isIllegal == true) then
						TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
					end
				end
			end
			
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, strResult)
			
		elseif(db.driver == "mysql-async") then
			MySQL.Async.fetchAll("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '"..identifier.."'", { ['@username'] = identifier }, function (result)
				local strResult = "Items de " .. GetPlayerName(target) .. " : "
				
				for _, v in ipairs(result) do
					if(v.quantity ~= 0) then
						strResult = strResult .. v.quantity .. " de " .. v.libelle .. ", "
					end
					
					if(v.isIllegal == "1" or v.isIllegal == "True" or v.isIllegal == 1 or v.isIllegal == true) then
						TriggerClientEvent('police:dropIllegalItem', target, v.item_id)
					end
				end
				
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, strResult)
			end)
		end
	end
	
	if(config.useWeashop == true) then
	
		if(db.driver == "mysql") then
			local strResult = "Armes de " .. GetPlayerName(target) .. " : "
		
			local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'", { ['@username'] = identifier })
			local result = MySQL:getResults(executed_query, { 'weapon_model' }, 'identifier' )
			if (result) then
				for _, v in ipairs(result) do
					strResult = strResult .. v.weapon_model .. ", "
				end
			end
			
			TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, strResult)
			
		elseif(db.driver == "mysql-async") then
			MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = '"..identifier.."'", { ['@username'] = identifier }, function (result)
				local strResult = "Armes de " .. GetPlayerName(target) .. " : "
				
				for _, v in ipairs(result) do
					strResult = strResult .. v.weapon_model .. ", "
				end
				
				TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, strResult)
			end)
		end
	end	
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(target, amount)
	TriggerClientEvent('police:payFines', target, amount, source)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, "Envoi d'une requête d'amende de  $"..amount.." à "..GetPlayerName(target))
end)

RegisterServerEvent('police:finesETA')
AddEventHandler('police:finesETA', function(officer, code)
	if(code==1) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, "Gouvernement", false, GetPlayerName(source).." à déjà une demande d'amende")
	elseif(code==2) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, "Gouvernement", false, GetPlayerName(source).." n'a pas répondu à la demande d'amende")
	elseif(code==3) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, "Gouvernement", false, GetPlayerName(source).." à refusé son amende")
	elseif(code==0) then
		TriggerClientEvent("police:notify", officer, "CHAR_ANDREAS", 1, "Gouvernement", false, GetPlayerName(source).." à payé son amende")
	end
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, "Tentative de mettre les menottes à "..GetPlayerName(t))
	TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent("police:notify", source, "CHAR_ANDREAS", 1, "Gouvernement", false, "Tentative de faire rentrer "..GetPlayerName(t).." dans la voiture")
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

-----------------------------------------------------------------------
----------------------EVENT SPAWN POLICE VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerClientEvent('FinishPoliceCheckForVeh',source)
	TriggerClientEvent('policeveh:spawnVehicle', source, vehicle)
end)

-----------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP COP-------------------
-----------------------------------------------------------------------
if(config.useCopWhitelist) then

	TriggerEvent('es:addGroupCommand', 'copadd', "admin", function(source, args, user)
		 if(not args[2]) then
			TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Usage : /copadd [ID]")	
		else
			if(GetPlayerName(tonumber(args[2])) ~= nil)then
				local player = tonumber(args[2])
				addCop(getPlayerID(player))
				TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Compris !")
				TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "Félicitation, vous êtes désormais policier !~w~.")
				TriggerClientEvent('police:nowCop', player)
			else
				TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Aucun joueur avec cet ID !")
			end
		end
	end, function(source, args, user) 
		TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
	end)

	TriggerEvent('es:addGroupCommand', 'coprem', "admin", function(source, args, user) 
		 if(not args[2]) then
			print("nein")
			TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Usage : /coprem [ID]")	
		else
			if(GetPlayerName(tonumber(args[2])) ~= nil)then
				local player = tonumber(args[2])
				remCop(getPlayerID(player))
				TriggerClientEvent("police:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "Vous n'êtes plus policier !~w~.")
				TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Compris !")
				TriggerClientEvent('police:noLongerCop', player)
			else
				TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Aucun joueur avec cet ID !")
			end
		end
	end, function(source, args, user) 
		TriggerClientEvent('chatMessage', source, 'Gouvernement', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
	end)
	
end

-- get's the player id without having to use bugged essentials
function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end