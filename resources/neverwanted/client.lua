local allowWanted = false

RegisterNetEvent("allowWanted")
AddEventHandler("allowWanted", function()
	if not allowWanted then
		allowWanted = true
                TriggerEvent("chatMessage", "", { 0, 0, 0 }, "Never Wanted: OFF!")
	else
		allowWanted = false
                TriggerEvent("chatMessage", "", { 0, 0, 0 }, "Never Wanted: ON!")
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not allowWanted then
			SetPlayerWantedLevel(PlayerId(), 0, false)
			SetPlayerWantedLevelNow(PlayerId(), false)
			ClearAreaOfCops()
			SetPoliceIgnorePlayer(PlayerId(), true)
			SetDispatchCopsForPlayer(PlayerId(), false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 1, false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 2, false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 3, false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 5, false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 8, false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 9, false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 10, false)
			Citizen.InvokeNative(0xDC0F817884CDD856, 11, false)
		end

		if allowWanted then
		end
	end
end)