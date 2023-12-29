local ESX = nil
local QBCore = nil 
local FrameworkFound = nil

LoadFramework = function()
    if Config.Framework == 'esx' then 
        ESX = exports['es_extended']:getSharedObject()
        FrameworkFound = 'esx'
    elseif Config.Framework == 'qbcore' then 
        QBCore = exports["qb-core"]:GetCoreObject()
        FrameworkFound = 'qbcore'
    elseif Config.Framework == 'autodetect' then
        if GetResourceState('es_extended') == 'started' then 
            ESX = exports['es_extended']:getSharedObject()
            FrameworkFound = 'esx'
        elseif GetResourceState('qb-core') == 'started' then
            QBCore = exports["qb-core"]:GetCoreObject()
            FrameworkFound = 'qbcore'
        else
            FrameworkFound = 'standalone'
        end
    elseif Config.Framework == 'standalone' then
        FrameworkFound = 'standalone'
    end

    print('[Ricky-VinewoodSign] Framework found: ' .. FrameworkFound)
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then 
        LoadFramework()
    end
end)

Authorized = function(source)
    if FrameworkFound == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        for k, v in pairs(Config.AuthorizedGroups.group) do 
            if xPlayer.getGroup() == v then 
                return true
            end
        end
    elseif FrameworkFound == 'qbcore' then
        for k, v in pairs(Config.AuthorizedGroups.group) do 
            if QBCore.Functions.HasPermission(source, v) then 
                return true
            end
        end
    elseif FrameworkFound == 'standalone' then
        for k, v in pairs(Config.AuthorizedGroups.identifier) do 
            for k, v2 in pairs(GetPlayerIdentifiers(source)) do 
                if v2 == v then 
                    return true
                end
            end
        end
    end
    return false
end

GetFileData = function()
    local file = LoadResourceFile(GetCurrentResourceName(), Config.FileName)
    file = json.decode(file)
    return file
end

RegisterCommand(Config.Command, function(source, args, rawCommand)
    if not Authorized(source) then return 
    end
    TriggerClientEvent('ricky-vinewood:openNui', source, GetFileData()[1], GetFileData()[2])
end)

RegisterServerEvent('ricky-vinewood:saveText')
AddEventHandler('ricky-vinewood:saveText', function(data)
    if not Authorized(source) then return end
    local newText = data.text 
    local newColor = data.color
    local file = LoadResourceFile(GetCurrentResourceName(), Config.FileName)
    file = json.decode(file)
    file[1] = newText
    file[2] = newColor
    SaveResourceFile(GetCurrentResourceName(), Config.FileName, json.encode(file, {indent = true}), -1)
    TriggerClientEvent('ricky-vinewood:saveText', -1, file)
end)

RegisterServerEvent('ricky-vinewood:loadText')
AddEventHandler('ricky-vinewood:loadText', function()
    TriggerClientEvent('ricky-vinewood:saveText', source, GetFileData())
end)
