ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'concess', 'concess', 'society_concess', 'society_concess', 'society_concess', {type = 'public'})


ESX.RegisterServerCallback('CoffreBuilder:GetInventory', function(source, cb)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local items = xPlayer.getInventory()
    cb(items)
end)


ESX.RegisterServerCallback("CoffreBuilder:GetChestInventory", function(source, cb, Society)
    TriggerEvent('esx_addoninventory:getSharedInventory', Society, function(inventory)
        cb(inventory.items)
    end)
end)

RegisterNetEvent('CoffreBuilder:InventoryDepo')
AddEventHandler("CoffreBuilder:InventoryDepo", function(Society, QuantityDepo, name)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    TriggerEvent('esx_addoninventory:getSharedInventory', Society, function(inventory)
        local item = inventory.getItem()
        local PlayerItemCount = xPlayer.getInventoryItem(name).count
        if item.count >= 0 and QuantityDepo <= PlayerItemCount then
            xPlayer.removeInventoryItem(name, QuantityDepo)
            inventory.addItem(name, QuantityDepo)
            TriggerClientEvent('esx:showNotification', _src, "Vous avez déposé ~s~[ ~g~x"..QuantityDepo.." "..name.." ~s~] "..name.." dans le coffre")
        else
            TriggerClientEvent('esx:showNotification', _src, 'Quantité invalide')
        end
    end)
end)

RegisterNetEvent('Builder:TakeObject')
AddEventHandler('Builder:TakeObject', function(Society, QuantityTake, name)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    TriggerEvent('esx_addoninventory:getSharedInventory', Society, function(inventory)
        local item = inventory.getItem(name)
        if item.count >= QuantityTake then 
            inventory.removeItem(name, QuantityTake)
            xPlayer.addInventoryItem(name, QuantityTake)
            TriggerClientEvent('esx:showNotification', _src, "Vous avez retiré ~s~[ ~g~x"..QuantityTake.." "..name.." ~s~] du coffre")
        else 
            TriggerClientEvent('esx:showNotification', _src, 'Quantité invalide')
        end
    end)
end)