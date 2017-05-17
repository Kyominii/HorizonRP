local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

emotes = {
	["/sit"] = { cmd = '/sit', event = 'playSitEmote' },
	["/chair"] = { cmd = '/chair', event = 'playChairEmote' },
	["/kneel"] = { cmd = '/kneel', event = 'playKneelEmote' },
	["/notepad"] = { cmd = '/notepad', event = 'playNotepadEmote' },
	["/photo"] = { cmd = '/photo', event = 'playPhotoEmote' },
	["/lean"] = { cmd = '/lean', event = 'playLeanEmote' },
	["/smoke"] = { cmd = '/smoke', event = 'playSmokeEmote' },
	["/drink"] = { cmd = '/drink', event = 'playDrinkEmote' },
	["/cancelemote"] = { cmd = '/cancelemote', event = 'playCancelEmote' }
}
--[["/cop"] = { cmd = '/cop', event = 'playCopEmote' },
["/medic"] = { cmd = '/medic', event = 'playMedicEmote' },
["/traffic"] = { cmd = '/traffic', event = 'playTrafficEmote' },
["/clipboard"] = { cmd = '/clipboard', event = 'playClipboardEmote' },]]


--RegisterNetEvent('printInvalidEmote');
RegisterNetEvent('printEmoteList');
RegisterNetEvent('playCopEmote');
RegisterNetEvent('playSitEmote');
RegisterNetEvent('playChairEmote');
RegisterNetEvent('playKneelEmote');
RegisterNetEvent('playMedicEmote');
RegisterNetEvent('playNotepadEmote');
RegisterNetEvent('playTrafficEmote');
RegisterNetEvent('playPhotoEmote');
RegisterNetEvent('playClipboardEmote');
RegisterNetEvent('playLeanEmote');
RegisterNetEvent('playSmokeEmote');
RegisterNetEvent('playDrinkEmote');
RegisterNetEvent('playCancelEmote');

playing_emote = false;

--[[
playing_cop_emote = false;
playing_sit_emote = false;
playing_chair_emote = false;
playing_kneel_emote = false;
playing_medic_emote = false;
playing_notepad_emote = false;
playing_traffic_emote = false;
playing_photo_emote = false;
playing_clipboard_emote = false;
playing_lean_emote = false;
playing_smoke_emote = false;
playing_drink_emote = false;
]]--

AddEventHandler('printEmoteList', function()
	TriggerEvent('chatMessage', "^4ALERT", {255, 0, 0}, "^2Emote List: ^0cop, sit, chair, kneel, medic, notepad, traffic, photo, clipboard, lean, smoke, drink");
end)

--AddEventHandler('printInvalidEmote', function()
--	TriggerEvent('chatMessage', "^4ALERT", {255, 0, 0}, "^1Invalid emote specified, use /emotes");
--end)

--!!!DO NOT EDIT BELOW THIS LINE!!!

AddEventHandler('playSmokeEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playDrinkEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRINKING", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playCopEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playSitEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PICNIC", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playChairEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		pos = GetEntityCoords(ped);
		head = GetEntityHeading(ped);
		TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR", pos['x'], pos['y'], pos['z'] - 1, head, 0, 0, 1);
		--TaskStartScenarioInPlace(ped, "PROP_HUMAN_SEAT_CHAIR", 0, false);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playKneelEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playMedicEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playNotepadEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playTrafficEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playPhotoEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PAPARAZZI", 0, false);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playClipboardEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, false);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playLeanEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_LEANING", 0, true);
		playing_emote = true;
	end
	
	Menu.hidden = true
end)

AddEventHandler('playCancelEmote', function()
	ped = GetPlayerPed(-1);
	
	if ped then
		ClearPedTasks(ped);
		playing_emote = false
	end
	
	Menu.hidden = true
end)

function InitMenu()
	ClearMenu()
	Menu.addTitle("Emotes");
	--Menu.addButton("Police", "TriggerEvent", emotes["/cop"].event)
	Menu.addButton("S'asseoir", "TriggerEvent", emotes["/sit"].event)
	Menu.addButton("Chaise", "TriggerEvent", emotes["/chair"].event)
	Menu.addButton("S'agenouiller", "TriggerEvent", emotes["/kneel"].event)
	--Menu.addButton("Medecin", "TriggerEvent", emotes["/medic"].event)
	Menu.addButton("Bloc-note", "TriggerEvent", emotes["/notepad"].event)
	--Menu.addButton("Traffic", "TriggerEvent", emotes["/traffic"].event)
	Menu.addButton("Photo", "TriggerEvent", emotes["/photo"].event)
	--Menu.addButton("Clipboard", "TriggerEvent", emotes["/clipboard"].event)
	Menu.addButton("S'allonger", "TriggerEvent", emotes["/lean"].event)
	Menu.addButton("Fumer", "TriggerEvent", emotes["/smoke"].event)
	Menu.addButton("Boire", "TriggerEvent", emotes["/drink"].event)
	Menu.addButton("Annuler emote", "TriggerEvent", emotes["/cancelemote"].event)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, Keys["F6"]) then -- INPUT_CELLPHONE_DOWN
			InitMenu()                       
			Menu.hidden = not Menu.hidden    
		elseif IsControlJustPressed(1, 32) then -- INPUT_MOVE_UP_ONLY
			ClearPedTasks(ped);
			playing_emote = false
		end
		Menu.renderGUI()
	end
end)