# ap_createjob
 FiveM script for esx legacy where you can create jobs and job grades in game without the need to restart the server.

# How to use in game.

Make sure you are setup as an admin or superadmin in the esx database under users, once done you can open the menu in game by typeing /menujobs this should then open the menu to create new jobs and grades.

There is also discord webhook intergration in the server.lua file at the top, make sure to insert your webhook link before you create jobs or grades.


# Requirements

* [zf_context](https://github.com/zf-development/zf_context)
* [zf_dialog](https://github.com/zf-development/zf_dialog)

# es_extended/server/functions.lua - Anywhere in File

    ESX.RefreshJobs = function()
        ESX.Jobs = {}
        MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
            for k,v in ipairs(jobs) do
                ESX.Jobs[v.name] = v
                ESX.Jobs[v.name].grades = {}
            end
        
            MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
                for k,v in ipairs(jobGrades) do
                    if ESX.Jobs[v.job_name] then
                        ESX.Jobs[v.job_name].grades[tostring(v.grade)] = v
                    else
                        print(('[es_extended] [^3WARNING^7] Ignoring job grades for "%s" due to missing job'):format(v.job_name))
                    end
                end
            
                for k2,v2 in pairs(ESX.Jobs) do
                    if ESX.Table.SizeOf(v2.grades) == 0 then
                        ESX.Jobs[v2.name] = nil
                        print(('[es_extended] [^3WARNING^7] Ignoring job "%s" due to no job grades found'):format(v2.name))
                    end
                end
            end)
        end) 
    end
