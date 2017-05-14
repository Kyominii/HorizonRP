require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "space031")

function commandDenied(source)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You don't have the permission to do this !")
end

function badUsageCommand(source)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Usage : /ezw (add|rem) (stid|un(rm)|ip) (SteamID|Username(rm)|IP)")
end

function alreadyInWhitelist(source)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "User already whitelisted !")
end

function notInWhitelist(source)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "User not whitelisted !")
end


function successfullyPutInWhitelist(source)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "User add in the whitelist !")
end

function successfullyRemoveWhitelist(identifier)
	TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "User removed from the whitelist !")
end

function addStid(source, stid)
	local idFormatted = "steam:"..stid
	local isHere = checkIsAlreadyInWhitelist(idFormatted)
	if(isHere) then
		alreadyInWhitelist(source)
	else
		addInWhitelist(idFormatted)
		successfullyPutInWhitelist(source)
	end
end

function addIp(source, ip)
	local ipFormatted = "ip:"..ip
	local isHere = checkIsAlreadyInWhitelist(ipFormatted)
	if(isHere) then
		alreadyInWhitelist(source)
	else
		addInWhitelist(ipFormatted)
		successfullyPutInWhitelist(source)
	end
end

function remStid(source, stid)
	local idFormatted = "steam:"..stid
	local isHere = checkIsAlreadyInWhitelist(idFormatted)
	if(not isHere) then
		notInWhitelist(source)
	else
		removeFromWhitelist(idFormatted)
		successfullyRemoveWhitelist(source)
	end
end

function remUn(source, un)
	local isHere = checkIsAlreadyInWhitelist(un)
	if(not isHere) then
		notInWhitelist(source)
	else
		removeUsernameFromWhitelist(un)
		successfullyRemoveWhitelist(source)
	end
end

function remIp(source, ip)
	local ipFormatted = "ip:"..ip
	local isHere = checkIsAlreadyInWhitelist(ipFormatted)
	if(not isHere) then
		notInWhitelist(source)
	else
		removeFromWhitelist(ipFormatted)
		successfullyRemoveWhitelist(source)
	end
end

function checkIsAlreadyInWhitelist(identifier)
	local query = MySQL:executeQuery("SELECT count(*) AS isPresent FROM ezwhitelist WHERE identifier = '@identifier' OR username = '@identifier'", { ['@identifier'] = identifier})
	local result = MySQL:getResults(query, {'isPresent'}, "identifier")
	
	if(result[1]) then
		if(tonumber(result[1].isPresent) == 1) then
			return true
		end		
	end
	return false
end

function addInWhitelist(identifier)
	MySQL:executeQuery("INSERT INTO ezwhitelist (identifier) VALUES ('@identifier')", { ['@identifier'] = identifier})
end

function updateUsernameInWhitelist(identifier, username)
	MySQL:executeQuery("UPDATE ezwhitelist SET username = '@username' WHERE identifier = '@identifier' ", { ['@username'] = username, ['@identifier'] = identifier})
end

function removeFromWhitelist(identifier)
	MySQL:executeQuery("DELETE FROM ezwhitelist WHERE identifier='@identifier'", { ['@identifier'] = identifier})
end

function removeUsernameFromWhitelist(username)
	MySQL:executeQuery("DELETE FROM ezwhitelist WHERE username='@username'", { ['@username'] = username})
end

TriggerEvent('es:addAdminCommand', 'ezw', 100000, function(source, args, user) 
    if(#args < 4) then
		badUsageCommand(source)
	else
		if(args[2] == nil or args[3] == nil or args[4] == nil or args[2] == "" or args[3] == "" or args[4] == "") then
			badUsageCommand(source)
		else
			if(args[2] == "add") then
				if(args[3] == "stid") then
					addStid(source, args[4])
				elseif(args[3] == "ip") then
					addIp(source, args[4])
				else
					badUsageCommand(source)
				end
			elseif(args[2] == "rem") then
				if(args[3] == "stid") then
					remStid(source, args[4])
				elseif(args[3] == "un") then
					table.remove(args, 3)
					table.remove(args, 2)
					table.remove(args, 1)
					remUn(source, table.concat(args, " "))
				elseif(args[3] == "ip") then
					remIp(source, args[4])
				else
					badUsageCommand(source)
				end
			else
				badUsageCommand(source)
			end
		end
	end
end, function(source, args, user) 
	commandDenied(source)
end)

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'ezw' then
		if #args < 3 then
				RconPrint("Usage : /ezw (add|rem) (stid|un(rm)|ip) (SteamID|Username(rm)|IP)\n")
				CancelEvent()
				return
		end

		if(args[1] == nil or args[2] == nil or args[3] == nil or args[1] == "" or args[2] == "" or args[3] == "")then
			RconPrint("Usage : /ezw (add|rem) (stid|un(rm)|ip) (SteamID|Username(rm)|IP)\n")
			CancelEvent()
			return
		end

		if(args[1] == "add") then
				if(args[2] == "stid") then
					local isHere = checkIsAlreadyInWhitelist("steam:"..args[3])
	
					if(isHere) then
						RconPrint("Already whitelisted !\n")
						CancelEvent()
						return
					else
						addInWhitelist("steam:"..args[3])
						RconPrint("User add in the whitelist !\n")
						CancelEvent()
						return
					end
				elseif(args[2] == "ip") then
					local isHere = checkIsAlreadyInWhitelist(args[3])
	
					if(isHere) then
						RconPrint("Already whitelisted !\n")
						CancelEvent()
						return
					else
						addInWhitelist("ip:"..args[3])
						RconPrint("User add in the whitelist !\n")
						CancelEvent()
						return
					end
				else
					RconPrint("Usage : /ezw (add|rem) (stid|un(rm)|ip) (SteamID|Username(rm)|IP)\n")
					CancelEvent()
					return
				end
			elseif(args[1] == "rem") then
				if(args[2] == "stid") then
					local isHere = checkIsAlreadyInWhitelist(args[3])
	
					if(not isHere) then
						RconPrint("Use not whitelisted !\n")
						CancelEvent()
						return
					else
						removeFromWhitelist(args[3])
						RconPrint("User removed from the whitelist !\n")
						CancelEvent()
						return
					end
				elseif(args[2] == "un") then
					
					table.remove(args, 2)
					table.remove(args, 1)
					
					local username = table.concat(args, " ")				
					local isHere = checkIsAlreadyInWhitelist(username)
	
					if(not isHere) then
						RconPrint("User not whitelisted !\n")
						CancelEvent()
						return
					else
						removeUsernameFromWhitelist(username)
						RconPrint("User removed from the whitelist !\n")
						CancelEvent()
						return
					end
				elseif(args[2] == "ip") then
					local isHere = checkIsAlreadyInWhitelist("ip:"..args[3])
	
					if(not isHere) then
						RconPrint("User not whitelisted !\n")
						CancelEvent()
						return
					else
						removeFromWhitelist("ip:"..args[3])
						RconPrint("User removed from the whitelist !\n")
						CancelEvent()
						return
					end
				else
					RconPrint("Usage : /ezw (add|rem) (stid|un(rm)|ip) (SteamID|Username(rm)|IP)\n")
					CancelEvent()
					return
				end
			else
				RconPrint("Usage : /ezw (add|rem) (stid|un(rm)|ip) (SteamID|Username(rm)|IP)\n")
				CancelEvent()
				return
			end

		CancelEvent()
	end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
	local identifiers = GetPlayerIdentifiers(source)

	for i = 1, #identifiers do
		local identifier = identifiers[i]
		
		local isWhitelisted = checkIsAlreadyInWhitelist(identifier)

		if (not isWhitelisted) then
			setKickReason('You are not whitelisted !')
			CancelEvent()
		else
			updateUsernameInWhitelist(identifier, playerName)
		end
	end
end)