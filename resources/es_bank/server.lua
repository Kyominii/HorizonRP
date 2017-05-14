local banks = {
	["Banque_federal"] = {
		position = { ['x'] = 253.936, ['y'] = 225.325, ['z'] = 100.9 },
		reward = 300000,
		nameofbank = "Banque Fedral",
		lastrobbed = 0
	}
}


local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_bank:toofar')
AddEventHandler('es_bank:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Braquage annuler a la: ^2" .. banks[robb].nameofbank)
	end
end)

RegisterServerEvent('es_bank:rob')
AddEventHandler('es_bank:rob', function(robb)
	if banks[robb] then
		local bank = banks[robb]

		if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "Le coffre est vide. Tu dois attendre: ^2" .. (14400 - (os.time() - bank.lastrobbed)) .. "^0 seconds.")
			return
		end
		TriggerClientEvent('chatMessage', -1, 'ALERTE', {255, 0, 0}, "Forcage du coffre de la ^2" .. bank.nameofbank)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Tu lance le braquage de la: ^2" .. bank.nameofbank .. "^0, ne vas pas trop loin!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Alarme activée!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Le coffre sera fracturer dans 15 minutes et la tune sera a toi!")
		TriggerClientEvent('es_bank:currentlyrobbing', source, robb)
		banks[robb].lastrobbed = os.time()
		robbers[source] = robb
		local savedSource = source
		SetTimeout(1200000, function()
			if(robbers[savedSource])then
				TriggerClientEvent('es_bank:robberycomplete', savedSource, job)
				TriggerEvent('es:getPlayerFromId', savedSource, function(target) 
					if(target)then
						--target:addDirty_Money(bank.reward) 
						target:addMoney(bank.reward)
						TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Le braquage est terminer a la: ^2" .. bank.nameofbank)			
					end
				end)
			end
		end)
	end
end)