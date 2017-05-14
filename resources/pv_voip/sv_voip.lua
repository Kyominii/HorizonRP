AddEventHandler("playerSpawned", function(spawn)    
    TriggerClientEvent('pv:voip', source, 'default')
end)

TriggerEvent('es:addCommand', 'voip', function(source, args, user)

	TriggerClientEvent('pv:voip', source, 'default')

end)

TriggerEvent('es:addCommand', 'voip_w', function(source, args, user)

	TriggerClientEvent('pv:voip', source, 'whisper')

end)

TriggerEvent('es:addCommand', 'voip_y', function(source, args, user)

	TriggerClientEvent('pv:voip', source, 'yell')

end)