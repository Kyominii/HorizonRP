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
AddEventHandler('chatMessage', function(source, name, msg)
	if msg == "/emote" then
		CancelEvent();
		TriggerClientEvent('printEmoteList', source);
	elseif emotes[msg].cmd ~= nil then
		CancelEvent();
		TriggerClientEvent(emotes[msg].event, source);
	end
end)