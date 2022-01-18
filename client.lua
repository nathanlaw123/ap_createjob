ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local adminGrades = 'admin' or 'superadmin'

RegisterNetEvent('ap_createjob:notify')
AddEventHandler('ap_createjob:notify', function(msg)
	ESX.ShowNotification(msg)
end)

RegisterCommand("menujobs", function(source, args, raw)
	checkAdmin()
end, false)

function checkAdmin()
	ESX.TriggerServerCallback('ap_createjob:getAdmin', function(data)
		for k,v in pairs(data) do
			if v.group == adminGrades then
				TriggerEvent('ap_createjob:apadminmenu')
			else
				ESX.ShowNotification('You are not authorised to use this command!')
			end
		end
	end)
end

RegisterNetEvent('ap_createjob:apadminmenu')
AddEventHandler('ap_createjob:apadminmenu', function()
	local adminMain = {
        {
            id = 1,
            header = 'AP Admin Menu',
            txt = ''
        },
        {
            id = 2,
            header = 'Jobs Menu',
            txt = 'Click for jobs menu.',
            params = {
                event = 'ap_createjob:createjobMain',
                isServer = false,
                args = {}
            }
        },
		{
            id = 3,
            header = 'Items Menu',
            txt = 'Click for items menu.',
            params = {
                event = 'ap_createjob:createitemMain',
                isServer = false,
                args = {}
            }
        }
    }
	exports['zf_context']:openMenu(adminMain)
end)

RegisterNetEvent('ap_createjob:createjobMain')
AddEventHandler('ap_createjob:createjobMain', function()
	local jobMain = {
        {
            id = 1,
            header = 'Create Jobs',
            txt = ''
        },
        {
            id = 2,
            header = 'Add Jobs',
            txt = 'Add jobs to database.',
            params = {
                event = 'ap_createjob:addjob',
                isServer = false,
                args = {}
            }
        },
		{
            id = 3,
            header = 'Add Grades',
            txt = 'Add grades to database.',
            params = {
                event = 'ap_createjob:addgrade',
                isServer = false,
                args = {}
            }
        },
		{
            id = 4,
            header = 'Refresh Jobs',
            txt = 'Click to refresh jobs table.',
            params = {
                event = 'ap_createjob:RefreshJobs',
                isServer = true,
                args = {}
            }
        },
        {
            id = 5,
            header = 'Back',
            txt = 'Back to main menu.',
            params = {
                event = 'ap_createjob:apadminmenu',
                isServer = false,
                args = {}
            }
        }
    }
	exports['zf_context']:openMenu(jobMain)
end)

RegisterNetEvent('ap_createjob:addjob')
AddEventHandler('ap_createjob:addjob', function()
	local dialog = exports['zf_dialog']:DialogInput({
        header = "Make New Job", 
        rows = {
            {
                id = 0, 
                txt = "Job Name (lowercase)"
            },
            {
                id = 1, 
                txt = "Job label"
            },
			{
                id = 2, 
                txt = "Whitelisted (0 or 1)"
            },
        }
    })   
    if dialog ~= nil then
        if dialog[1].input == nil or dialog[2].input == nil or dialog[3].input == nil then
            ESX.ShowNotification('All fields need to be filled.')
        else
            ESX.TriggerServerCallback('ap_createjob:createJob', function(hasJob)
				if hasJob then
					ESX.ShowNotification('Job name: '..dialog[1].input..' Job label: '..dialog[2].input..' Whitelisted status: '..dialog[3].input..' has been added.')
					TriggerEvent('ap_createjob:addjob')
				end
			end, dialog[1].input, dialog[2].input, dialog[3].input)
        end
    end
end)

RegisterNetEvent('ap_createjob:addgrade')
AddEventHandler('ap_createjob:addgrade', function()
	local dialog = exports['zf_dialog']:DialogInput({
        header = "Make New Grade", 
        rows = {
            {
                id = 0, 
                txt = "Job Name (lowercase)"
            },
            {
                id = 1, 
                txt = "Job grade"
            },
			{
                id = 2, 
                txt = "Grade name (lowercase)"
            },
			{
                id = 3, 
                txt = "Grade label"
            },
			{
                id = 4, 
                txt = "Salary ($)"
            },
        }
    })   
    if dialog ~= nil then
        if dialog[1].input == nil or dialog[2].input == nil or dialog[3].input == nil or dialog[4].input == nil or dialog[5].input == nil then
            ESX.ShowNotification('All fields need to be filled.')
        else
            ESX.TriggerServerCallback('ap_createjob:createRank', function(hasGrade)
				if hasGrade then
					ESX.ShowNotification('Rank name: '..dialog[3].input..' Rank label: '..dialog[4].input..' Rank salary: $'..dialog[5].input..' for job '..dialog[1].input..' has been added.')
					TriggerEvent('ap_createjob:addgrade')
				end
			end, dialog[1].input, dialog[3].input, dialog[4].input, dialog[2].input, dialog[5].input)
        end
    end
end)

RegisterNetEvent('ap_createjob:createitemMain')
AddEventHandler('ap_createjob:createitemMain', function()
	local itemMain = {
        {
            id = 1,
            header = 'Create Items',
            txt = ''
        },
        {
            id = 2,
            header = 'Add Items',
            txt = 'Add items to database.',
            params = {
                event = 'ap_createjob:additem',
                isServer = false,
                args = {}
            }
        },
		{
            id = 3,
            header = 'Refresh Items',
            txt = 'Click to refresh items table.',
            params = {
                event = 'ap_createjob:RefreshItems',
                isServer = true,
                args = {}
            }
        },
        {
            id = 4,
            header = 'Back',
            txt = 'Back to main menu.',
            params = {
                event = 'ap_createjob:apadminmenu',
                isServer = false,
                args = {}
            }
        }
    }
	exports['zf_context']:openMenu(itemMain)
end)

RegisterNetEvent('ap_createjob:additem')
AddEventHandler('ap_createjob:additem', function()
	local dialog = exports['zf_dialog']:DialogInput({
        header = "Make New Item", 
        rows = {
            {
                id = 0, 
                txt = "Item name (lowercase)"
            },
            {
                id = 1, 
                txt = "Item label"
            },
			{
                id = 2, 
                txt = "Item weight"
            },
            {
                id = 3, 
                txt = "Item rare"
            },
            {
                id = 4, 
                txt = "Item can_remove"
            },
        }
    })   
    if dialog ~= nil then
        if dialog[1].input == nil or dialog[2].input == nil or dialog[3].input == nil or dialog[4].input == nil or dialog[5].input == nil then
            ESX.ShowNotification('All fields need to be filled.')
        else
            ESX.TriggerServerCallback('ap_createjob:createItem', function(hasItem)
				if hasItem then
					ESX.ShowNotification(' Item label: '..dialog[2].input..' has been added.')
					TriggerEvent('ap_createjob:createitemMain')
				end
			end, dialog[1].input, dialog[2].input, dialog[3].input, dialog[4].input, dialog[5].input)
        end
    end
end)