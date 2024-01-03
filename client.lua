local ESX = nil
local QBCore = nil 
local FrameworkFound = nil
local nuiOpen = false
local modelCreated = {}

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
end

Citizen.CreateThread(function()
    LoadFramework()
    TriggerServerEvent('ricky-vinewood:loadText')
end)

RegisterNetEvent('ricky-vinewood:openNui')
AddEventHandler('ricky-vinewood:openNui', function(text, color)
    nuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "SET_LOCALES",
        locales = Config.Locales
    })
    SendNUIMessage({
        type = "OPEN",
        text = text,
        color = color
    })
end)

RegisterNUICallback('saveText', function(data)
    TriggerServerEvent('ricky-vinewood:saveText', data)
end)

RegisterNUICallback('close', function(data)
    nuiOpen = false
    SetNuiFocus(false, false)
end)

RegisterNetEvent('ricky-vinewood:saveText')
AddEventHandler('ricky-vinewood:saveText', function(data)
    UpdateMap(data)
    if nuiOpen then 
        SendNUIMessage({
            type = "UPDATE",
            text = data[1],
            color = data[2]
        })
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(modelCreated) do
            DeleteEntity(v)
        end
    end
end)

hexToRgb = function(hex)
    hex = hex:gsub("#","")
    return {
        r = tonumber("0x"..hex:sub(1,2)),
        g = tonumber("0x"..hex:sub(3,4)),
        b = tonumber("0x"..hex:sub(5,6))
    }
end

UpdateMap = function(data)
    for k, v in pairs(modelCreated) do
        DeleteEntity(v)
    end
    modelCreated = {}
    if not data then return end
    local completeText = data[1]
    if not completeText then return end
    for i=1, #completeText, 1 do 
        if i > 8 then 
            return 
        end
        local string = completeText:sub(i, i)
        local model = string
        local coords = Config.Coords[i].coordinate
        local heading = Config.Coords[i].heading
        model = model
        if model ~= " " then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(1)
            end

            local obj = CreateObject(model, coords, false, false, false)
            SetEntityHeading(obj, heading)
            table.insert(modelCreated, obj)
            SetColorModel(model, "techdevontop", hexToRgb(data[2]))
        end
    end
end

SetColorModel = function(model, textureName, colorRgb)
    local txd = 'txd_vinewood_sign'
    local txn = 'txn_vinewood_sign'
    local dict = CreateRuntimeTxd(txd)
    local texture = CreateRuntimeTexture(dict, txn, 4, 4)
    local resolution = GetTextureResolution(txd, txn)
    if(colorRgb.r == 255 and colorRgb.g == 255 and colorRgb.b == 255) then
        RemoveReplaceTexture("mainTexture", textureName)
    else
        SetRuntimeTexturePixel(texture, 0, 0, colorRgb.r, colorRgb.g, colorRgb.b, 255)
        CommitRuntimeTexture(texture)
        AddReplaceTexture("mainTexture", textureName, txd, txn)  
    end  
end
