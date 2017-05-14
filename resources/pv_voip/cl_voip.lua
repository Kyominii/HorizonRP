local voip = {}
voip['default'] = {name = 'parlez normalement', setting = 5.0}
voip['local'] = {name = 'local', setting = 5.0}
voip['whisper'] = {name = 'chuchotez', setting = 2.0}
voip['yell'] = {name = 'hurlez', setting = 25.0}

local radio = false

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(voip['default'].setting)
end)

function RadioTalk()
	if not radio then
		radio = true
		NotificationMessage("Vous parlez sur le canal 1")
		NetworkSetVoiceChannel(1)
		NetworkSetVoiceActive(true)
	elseif radio then
		radio = false
		NotificationMessage("Vous parlez normallement")
		--NetworkSetTalkerProximity(voip['default'].setting)
    	N_0xe036a705f989e049()
    	NetworkSetVoiceActive(true)
    end
end



--[[Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 213) or IsDisabledControlJustPressed(0, 213) then
			RadioTalk()
        end
    end
end)]]

RegisterNetEvent('pv:voip')
AddEventHandler('pv:voip', function(voipDistance)

		distanceName = voip['default'].name
		distanceSetting = voip['default'].setting
	
	NotificationMessage("Vous ~b~" .. distanceName ..".")
	NetworkSetTalkerProximity(distanceSetting)
		
end)

RegisterNetEvent('pv:voip_w')
AddEventHandler('pv:voip_w', function(voipDistance)

		distanceName = voip['whisper'].name
		distanceSetting = voip['whisper'].setting
	
	NotificationMessage("Vous ~b~" .. distanceName ..".")
	NetworkSetTalkerProximity(distanceSetting)
		
end)

RegisterNetEvent('pv:voip_y')
AddEventHandler('pv:voip_y', function(voipDistance)

		distanceName = voip['yell'].name
		distanceSetting = voip['yell'].setting
	
	NotificationMessage("Vous ~b~" .. distanceName ..".")
	NetworkSetTalkerProximity(distanceSetting)
		
end)

function NotificationMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end
