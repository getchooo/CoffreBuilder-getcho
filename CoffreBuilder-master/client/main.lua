ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	Citizen.Wait(5000)
end)

CreateThread(function()
    while true do 
        local interval = 500
        local PlayerPos = GetEntityCoords(PlayerPedId())
        for i = 1, #CoffreBuilder do
            local v = CoffreBuilder[i]
            local Dest = v.Point
            local Dist = #(PlayerPos-Dest)
            if Dist <= 5 then 
                interval = 0
                for _, gradejob in pairs(v.GradeJob) do
                    if ESX.PlayerData.job.name == v.NameJob and ESX.PlayerData.job.grade_name == gradejob then  
                        DrawMarker(6,Dest, 0.0, 0.0, 0.0, -90.0, -90.0, -90.0, 1.0, 1.0, 1.0, 255, 0, 0, 55555, false, false, 2, false, false, false, false)
                        if Dist <= 3 then 
                            ESX.ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le menu")
                            if IsControlJustPressed(1, 51) then
                                OpenMenuCoffreBuilder(v)
                            end
                        end
                    end
                end
            end
        end
        Wait(interval)
    end
end)


local Inventory = {}
local Coffre = {}
local OpenCoffreBuilder = false 
MenuCoffreBuilder = RageUI.CreateMenu("Coffre", " ")
MenuDeposerCoffreBuilder = RageUI.CreateSubMenu(MenuCoffreBuilder, "Coffre", " ")
MenuRetirerCoffreBuilder = RageUI.CreateSubMenu(MenuCoffreBuilder, "Coffre", " ")
MenuCoffreBuilder.Closed = function()
    OpenCoffreBuilder = false
end

function OpenMenuCoffreBuilder(info)
    if OpenCoffreBuilder then
        OpenCoffreBuilder = false 
        RageUI.Visible(MenuCoffreBuilder, false)
        return 
    else
        OpenCoffreBuilder = true 
        RageUI.Visible(MenuCoffreBuilder, true)
        CreateThread(function()
            while OpenCoffreBuilder do 
                RageUI.IsVisible(MenuCoffreBuilder, function()
                    RageUI.Separator(("~b~Entreprise : %s"):format(info.LabelJob))
                    RageUI.Line()
                    RageUI.Button("Déposer un objet", nil, {}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('CoffreBuilder:GetInventory', function(items) 
                                Inventory = {}
                                Inventory = items
                            end)
                        end
                    }, MenuDeposerCoffreBuilder)
                    RageUI.Button("Retirer un objet", nil, {}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('CoffreBuilder:GetChestInventory', function(items) 
                                Coffre = {}
                                Coffre = items
                            end, info.Society)
                        end
                    }, MenuRetirerCoffreBuilder)
                end)
                RageUI.IsVisible(MenuDeposerCoffreBuilder, function()
                    for k,v in pairs(Inventory) do
                        if v.count > 0 then
                            RageUI.Button("[~b~x"..v.count.."~s~] - "..v.label, nil, {RightLabel = "x"..v.count}, true, {
                                onSelected = function()
                                    local QuantityDepo = Visual.KeyboardNumber("Choissisez un nombre", "", 5) 
                                    if type(QuantityDepo) == "number" then
                                        TriggerServerEvent("CoffreBuilder:InventoryDepo", info.Society, QuantityDepo, v.name)
                                        ESX.TriggerServerCallback('CoffreBuilder:GetInventory', function(items) 
                                            Inventory = {}
                                            Inventory = items
                                        end)
                                    else 
                                        ESX.ShowNotification("~r~Veuillez indiquer un chiffre correct !")
                                    end
                                end
                            })
                        end
                    end
                end)
                RageUI.IsVisible(MenuRetirerCoffreBuilder, function()
                    for k,v in pairs(Coffre) do 
                        if v.count > 0 then
                            RageUI.Button("[~b~x"..v.count.."~s~] - "..v.label, nil, {}, true, {
                                onSelected = function()
                                    local QuantityTake = Visual.KeyboardNumber("Choissisez un nombre", "", 5)
                                    if type(QuantityTake) == "number" then
                                        TriggerServerEvent("Builder:TakeObject", info.Society, QuantityTake, v.name)
                                        ESX.TriggerServerCallback('CoffreBuilder:GetChestInventory', function(items) 
                                            Coffre = {}
                                            Coffre = items
                                        end, info.Society)
                                    else
                                        ESX.ShowNotification("~r~Veuillez indiquer un chiffre correct !")
                                    end
                                end
                            })
                        end
                    end
                end)
            Wait(0)
            end
        end)
    end
end