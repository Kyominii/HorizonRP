require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "root", "space031")


function nameJob(id)
  local executed_query = MySQL:executeQuery("SELECT * FROM jobs WHERE job_id = '@namejob'", {['@namejob'] = id})
  local result = MySQL:getResults(executed_query, {'job_name'}, "job_id")
  return result[1].job_name
end

function updatejob(player, id, isConnected)
  local job = id
  MySQL:executeQuery("UPDATE users SET `job`='@value' WHERE identifier = '@identifier'", {['@value'] = job, ['@identifier'] = player})
  if(isConnected) then
	TriggerClientEvent("recolt:updateJobs", source, job)
  end
end

RegisterServerEvent('jobssystem:jobs')
AddEventHandler('jobssystem:jobs', function(id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local nameJob = nameJob(id)
        updatejob(player, id, true)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_STRIPCLUB_PR", 1, "Mairie", false, "Votre métier est maintenant : ".. nameJob)
  end)
end)

RegisterServerEvent('jobssystem:disconnectReset')
AddEventHandler('jobssystem:disconnectReset', function(user, id)
	local player = user.identifier
	local nameJob = nameJob(id)
	updatejob(player, id, false)
end)

RegisterServerEvent('jobssystem:spawnGetJob')
AddEventHandler('jobssystem:spawnGetJob', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@id'", {['@id'] = player})
		local result = MySQL:getResults(executed_query, {'job'}, "job_id")
		TriggerClientEvent("recolt:updateJobs", source, result[1].job)
  end)
end)

