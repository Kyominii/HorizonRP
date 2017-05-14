skins = {
	{
		name = "mp_f_freemode_01",
		display = "Femme"
	},
	{
		name = "mp_m_freemode_01",
		display = "Homme"
	}
}

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

local isSpawnedInHospitalOnDeath = true

RegisterNetEvent("skin_customization:Customization")
RegisterNetEvent("skin_customization:OnDeath")

function InitMenu()
	ClearMenu()
	Menu.addTitle("Choisissez un skin");
   	Menu.addButton(skins[2].display, "SendSkin", skins[2].name);
	Menu.addButton(skins[1].display, "SendSkin", skins[1].name);
end

function SendSkin(skin)
    TriggerServerEvent("skin_customization:ChoosenSkin",skin)
end

--Notification joueur
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

AddEventHandler("skin_customization:Customization",function(skin)
    ChangeSkin(skin,nil)
	--Notify("Skin chargé")
	InitDrawMenu()
end)

AddEventHandler("skin_customization:OnDeath",function()
	print("ondeath")
	if isSpawnedInHospitalOnDeath then
		SetEntityCoords(GetPlayerPed(-1), 295.83, -1446.94, 29.97, 1, 0, 0, 1) -- Hospital
		print("spawn")
	end
	TriggerServerEvent("skin_customization:SpawnPlayer")
end)

RegisterNetEvent("skin_customization:updateComponents")
AddEventHandler("skin_customization:updateComponents",function(args)
		ChangeComponent({0,0,args[1],args[2]})-- 1:componentID; 2: page; 3: drawbleID; 4: textureID
		ChangeComponent({2,0,args[3],args[4]})
		ChangeComponent({4,0,args[5],args[6]})
		ChangeComponent({6,0,args[7],args[8]})
		ChangeComponent({11,0,args[9],args[10]})
		ChangeComponent({8,0,args[11],args[12]})
		Notify("Skin et composants chargés")
end)

function InitDrawMenu()
	ClearMenu()
	Menu.addButton("Visage","DrawableChoice",{0,0})
	Menu.addButton("Cheveux","DrawableChoice",{2,0})
	Menu.addButton("Torse","DrawableChoice",{11,0})
	Menu.addButton("T-shirt","DrawableChoice",{8,0})
	Menu.addButton("Pantalon","DrawableChoice",{4,0})
	Menu.addButton("Chaussures","DrawableChoice",{6,0})
end

function DrawableChoice(args)
	ClearMenu()
	local max = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), args[1])

	if max > (args[2]+1)*8 then
		max = (args[2]+1)*8
	end
	if args[2] > 0 then
		Menu.addButton("Page précédente","DrawableChoice",{args[1],args[2]-1})
	end
	for i = args[2]*8,max-1 do				
		Menu.addButton("Draw: "..i,"TextureChoice",{args[1],0,i})
	end
	if max <= (args[2]+1)*8 then
		Menu.addButton("Page suivante","DrawableChoice",{args[1],args[2]+1})
	end
	Menu.addButton("Retour","InitDrawMenu","")
end

function TextureChoice(args)
	ClearMenu()
	local max = GetNumberOfPedTextureVariations(GetPlayerPed(-1),args[1],args[3])
	if max > (args[2]+1)*8 then
		max = (args[2]+1)*8
	end
	if args[2] > 0 then
		Menu.addButton("Page précédente","TextureChoice",{args[1],args[2]-1,args[3]})
	end
	for i = args[2]*8,max-1 do
		if IsPedComponentVariationValid(GetPlayerPed(-1), args[1], args[3], i) then
			Menu.addButton("Text: "..i,"ChangeComponent",{args[1],args[2],args[3],i})
		end
	end
	if max <= (args[2]+1)*8 then
		Menu.addButton("Page suivante","TextureChoice",{args[1],args[2]+1,args[3]})
	end
	Menu.addButton("Retour","DrawableChoice",args)
end

function ChangeComponent(args)-- 1:componentID; 2: page; 3: drawbleID; 4: textureID
	SetPedComponentVariation(GetPlayerPed(-1), args[1], args[3], args[4], 2)
	TriggerServerEvent("skin_customization:SaveComponents",args)
end
AddEventHandler('onPlayerDied', function(playerId, reason, position)
	print("ondeath")
	if isSpawnedInHospitalOnDeath then
		SetEntityCoords(GetPlayerPed(-1), 295.83, -1446.94, 29.97, 1, 0, 0, 1) -- Hospital
		print("spawn")
	end
	TriggerServerEvent("skin_customization:SpawnPlayer")
end)

--Action lors du spawn du joueur
local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
--On verifie que c'est bien le premier spawn du joueur
--if firstspawn == 0 then
	TriggerServerEvent("skin_customization:SpawnPlayer")
--	firstspawn = 1
--end
end)

function ChangeSkin(skin,components)
	--Menu.hidden = true
	-- Get model hash.
	local modelhashed = GetHashKey(skin)

    
    -- Request the model, and wait further triggering untill fully loaded.
	RequestModel(modelhashed)
	while not HasModelLoaded(modelhashed) do 
	    RequestModel(modelhashed)
	    Citizen.Wait(0)
	end
    -- Set playermodel.
	SetPlayerModel(PlayerId(), modelhashed)

	if components == nil then
		local playerPed = GetPlayerPed(-1)
	 	--SET_PED_COMPONENT_VARIATION(Ped ped, int componentId, int drawableId, int textureId, int paletteId)
		 --SetPedComponentVariation(playerPed, 0, 0, 0, 2) --Face
		 --SetPedComponentVariation(playerPed, 2, 11, 4, 2) --Hair 
		 --SetPedComponentVariation(playerPed, 4, 1, 5, 2) -- Pantalon
		 --SetPedComponentVariation(playerPed, 6, 1, 0, 2) -- Shoes
		 --SetPedComponentVariation(playerPed, 11, 7, 2, 2) -- Jacket
		 TriggerServerEvent("skin_customization:ChoosenComponents")
	end
	local a = "" -- nil doesnt work
	 TriggerServerEvent("weaponshop:playerSpawned",a)
	 TriggerServerEvent("item:getItems")
	SetModelAsNoLongerNeeded(modelhashed)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, Keys[","]) then -- INPUT_CELLPHONE_DOWN
			InitMenu()                       
			Menu.hidden = not Menu.hidden    
		end
		Menu.renderGUI()
	end
end)