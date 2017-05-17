require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

local charset = {}

-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
--for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function stringrandom(length)
  math.randomseed(os.time())

  if length > 0 then
    return stringrandom(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

RegisterServerEvent('CheckMoneyForVeh')
RegisterServerEvent('BuyForVeh')
RegisterServerEvent('CheckPlateExisting')

AddEventHandler('CheckMoneyForVeh', function(name, vehicle, price)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local vehicle = vehicle
    local name = name
    local price = tonumber(price)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username'",{['@username'] = player})
    local result = MySQL:getResults(executed_query, {'vehicle_model'})

    if (result) then
      count = 0
      for _ in pairs(result) do
        count = count + 1
      end
      if count == 5 then
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Garage plein!\n")
      else
        if (tonumber(user.money) >= tonumber(price)) then
          user:removeMoney((price))
          TriggerClientEvent('FinishMoneyCheckForVeh', source, name, vehicle, price)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Bonne route!\n")
        else
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Fonds insuffisants!\n")
       end
      end
   else
      if (tonumber(user.money) >= tonumber(price)) then
        user:removeMoney((price))
        TriggerClientEvent('FinishMoneyCheckForVeh', source, name, vehicle, price)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Bonne route!\n")
      else
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Fonds insuffisants!\n")
      end 
    end
  end)
end)

AddEventHandler('CheckPlateExisting', function(plate)
  local valid = false
  while(valid == false) do
	local executed_query = MySQL:executeQuery("SELECT Count(*) AS total FROM user_vehicle WHERE vehicle_plate = '@plate'", { ['@plate'] = plate })
	local result = MySQL:getResults(executed_query, { 'total' }, "identifier")
	if (result[1]) then
		if(result[1].total ~= 0) then
			plate = stringrandom(8)
		else
			TriggerClientEvent("vehshop:sendPlate", source, plate)
			valid = true
		end
	end
  end
end)

AddEventHandler('BuyForVeh', function(name, vehicle, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
  TriggerEvent('es:getPlayerFromId', source, function(user)

    local player = user.identifier
    local name = name
    local price = price
    local vehicle = vehicle
    local plate = plate
    local state = "Sortit"
    local primarycolor = primarycolor
    local secondarycolor = secondarycolor
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor
    local executed_query = MySQL:executeQuery("INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`) VALUES ('@username', '@name', '@vehicle', '@price', '@plate', '@state', '@primarycolor', '@secondarycolor', '@pearlescentcolor', '@wheelcolor')",
    {['@username'] = player, ['@name'] = name, ['@vehicle'] = vehicle, ['@price'] = price, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor})

  end)
end)

--[[TriggerEvent('es:addCommand', 'pv', function(source, user)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local executed_query = MySQL:executeQuery("SELECT * FROM user_vehicle WHERE identifier = '@username'",{['@username'] = player})
  	local result = MySQL:getResults(executed_query, {'vehicle_model'})

    if(result)then
		for k,v in ipairs(result)do
      vehicle = v.vehicle_model
      end
    end

  	TriggerClientEvent('vehshop:spawnVehicle', source, vehicle)
  end)
end)]]