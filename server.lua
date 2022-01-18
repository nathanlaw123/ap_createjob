local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Discord_url = ""

ESX.RegisterServerCallback('ap_createjob:getAdmin',function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(results)
		cb(results)
	end)
end)

ESX.RegisterServerCallback('ap_createjob:createRank',function(source, cb, jobName, rankName, rankLabel, rankGrade, rankSalary)
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = xPlayer.getName()
    if (jobName and rankName and rankLabel and rankGrade and rankSalary) then
		MySQL.Async.fetchAll(
			'INSERT INTO job_grades(job_name, name, label, grade, salary, skin_male, skin_female) VALUES (@jobName, @rankName, @rankLabel, @rankGrade, @rankSalary, "{}", "{}");',
			{
				['@jobName'] = jobName,
				['@rankName'] = rankName,
				['@rankLabel'] = rankLabel,
				['@rankGrade'] = rankGrade,
				['@rankSalary'] = rankSalary
			}, function(result)
				if result then		
					TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Successful')
					sendLogsDiscord(source, name, "Job name: "..jobName.." | Rank name: "..rankName.." | Rank label: "..rankLabel.." | Rank grade: "..rankGrade.." | Rank salary: $"..rankSalary.." | Added to the database.")
					cb(true)
				else
					TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Couldnt create rank (database error)')
					cb(false)
				end
			end)
	else
		TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Couldnt create rank, argument missing')
		cb(false)
	end
end)

ESX.RegisterServerCallback('ap_createjob:createJob',function(source, cb, jobName, jobLabel, jobWhitelisted)
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = xPlayer.getName()
    if (jobName and jobLabel and jobWhitelisted) then
		MySQL.Async.fetchAll(
			'INSERT INTO jobs(name, label, whitelisted) VALUES (@jobName, @jobLabel, @jobWhitelisted);',
			{
				['@jobName'] = jobName,
				['@jobLabel'] = jobLabel,
				['@jobWhitelisted'] = jobWhitelisted
			}, function(result)
				if result then		
					TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Successful')
					sendLogsDiscord(source, name, "Job name: "..jobName.." | Job label: "..jobLabel.." | Whitelisted status: "..jobWhitelisted.." | Added to the database.")
					cb(true)
				else
					TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Couldnt create job (database error)')
					cb(false)
				end
			end)
	else
		TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Couldnt create job, argument missing')
		cb(false)
	end
end)

ESX.RegisterServerCallback('ap_createjob:createItem',function(source, cb, itemName, itemLabel, itemWeight, itemRare, itemCanRemove)
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = xPlayer.getName()
    if (itemName and itemLabel and itemWeight and itemRare and itemCanRemove) then
		MySQL.Async.fetchAll(
			'INSERT INTO items(name, label, weight, rare, can_remove) VALUES (@itemName, @itemLabel, @itemWeight, @itemRare, @itemCanRemove);',
			{
				['@itemName'] = itemName,
				['@itemLabel'] = itemLabel,
				['@itemWeight'] = itemWeight,
				['@itemRare'] = itemRare,
				['@itemCanRemove'] = itemCanRemove
			}, function(result)
				if result then		
					TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Successful')
					sendLogsDiscord(source, name, "Item name: "..itemName.." | Item label: "..itemLabel.." | Item weight: "..itemWeight.." | Item rare: "..itemRare.." | Item can_remove: "..itemCanRemove.." | Added to the database.")
					cb(true)
				else
					TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Couldnt create item (database error)')
					cb(false)
				end
			end)
	else
		TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Couldnt create item, argument missing')
		cb(false)
	end
end)

RegisterServerEvent("ap_createjob:RefreshJobs")
AddEventHandler("ap_createjob:RefreshJobs", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = xPlayer.getName()
    ESX.RefreshJobs()
    TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Jobs have been refreshed!')
	sendLogsDiscord(source, name, "Jobs have been refreshed!")
	TriggerClientEvent('ap_createjob:createjobMain', xPlayer.source)
end)

RegisterServerEvent("ap_createjob:RefreshItems")
AddEventHandler("ap_createjob:RefreshItems", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    ESX.RefreshItems()
    TriggerClientEvent('ap_createjob:notify', xPlayer.source, 'Items have been refreshed!')
    sendLogsDiscord(source, name, "Items have been refreshed!")
    TriggerClientEvent('ap_createjob:createitemMain', xPlayer.source)
end)

sendLogsDiscord = function(color, name, message)
	local embed = {
		  {
			  ["color"] = 3085967,
			  ["title"] = "**".. name .."**",
			  ["description"] = message
		  }
	  }
  
	PerformHttpRequest(Discord_url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end