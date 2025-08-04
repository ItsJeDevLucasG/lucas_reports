ESX = exports["es_extended"]:getSharedObject()

local reports = {}
local cooldowns = {}

RegisterCommand('report', function(source, args, rawCommand)
    if not cooldowns[source] or cooldowns[source] == nil then
        local reportCode = math.random(1000,9999)
        local reden = rawCommand:sub(8)

        reports[reportCode] = source
        cooldowns[source] = 60

        TriggerClientEvent('lucas:reports:sendNotify', source, 'success', 'Je hebt succesvol een report aangemaakt met de reden: ' .. reden)

        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer.getGroup() ~= "user" then
                TriggerClientEvent('lucas:reports:sendChat', playerId, 'Er is een nieuwe report binnengekomen! De reden voor de report: ' .. reden .. ' . Als je deze report wilt claimen voor de command: /claimreport ' .. reportCode .. ' uit.')
            end
        end

        Citizen.CreateThread(function()
            while cooldowns[source] and cooldowns[source] > 0 do
                Citizen.Wait(1000)
                cooldowns[source] = cooldowns[source] - 1
                if cooldowns[source] <= 0 then
                    cooldowns[source] = nil
                end
            end
        end)
    else
        TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Je moet nog ' .. cooldowns[source] .. ' seconden wachten voor dat je een nieuwe report kan aanmaken.')
    end
end)

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ', '
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

RegisterCommand('claimreport', function(source, args, rawCommand)
    if not IsStaff(source) then
        return TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Je hebt geen permissions.')
    end

    if not IsStaffInDienst(source) then
        return TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Je bent niet in staffdienst.')
    end

    if not args[1] then return TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Je moet wel een reportcode opgeven.') end

    local adminPlayer = ESX.GetPlayerFromId(source)
    local code = tonumber(args[1])
    local target = ESX.GetPlayerFromId(reports[code])

    local targetId = reports[code]
    if not targetId then
        TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Deze report bestaat niet.')
        return
    end

    if not target then
        reports[code] = nil
        TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Deze speler is niet meer in de stad.')
    end

    local targetPed = GetPlayerPed(reports[code])
    local adminPed = GetPlayerPed(source)
    local targetCoords = GetEntityCoords(targetPed)

    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer.getGroup() ~= "user" then
            TriggerClientEvent('lucas:reports:sendChat', playerId, 'De report met de code: ' .. args[1] .. ' is geclaimed door: [TRP] ' .. GetPlayerName(source))
        end
    end

    SetEntityCoords(adminPed, targetCoords.x, targetCoords.y, targetCoords.z + 1, false, false, false, false)
    
    adminPlayer.addAccountMoney('bank', 500)

    print(reports[code])
    TriggerClientEvent('lucas:reports:sendChat', reports[code], 'Je report is geclaimed door: [TRP] ' .. GetPlayerName(source))
    TriggerClientEvent('lucas:reports:sendNotify', source, 'success', 'Je hebt succesvol de report geclaimed.')

    reports[code] = nil
end)

RegisterCommand('reply', function(source, args, rawCommand)
    if not IsStaff(source) then
        return TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Je hebt geen permissions.')
    end

    if not IsStaffInDienst(source) then
        return TriggerClientEvent('lucas:reports:sendNotify', source, 'error', 'Je bent niet in staffdienst.')
    end

    local reply = table.concat(args, " ", 2)

    TriggerClientEvent('lucas:reports:sendChat', args[1], 'De admin: [TRP] ' .. GetPlayerName(source) .. ' heeft een reply naar je gestuurd, de reply: ' .. reply .. '.')
    TriggerClientEvent('lucas:reports:sendNotify', source, 'success', 'Je hebt succesvol de reply gestuurd naar Id: ' .. args[1] .. '.')
end)