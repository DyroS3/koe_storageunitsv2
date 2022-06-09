----Gets ESX-------------------------------------------------------------------------------------------------------------------------------
storageID = nil
rentBalance = nil
local npcSpawned = false
local npc

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()

end)

Citizen.CreateThread(function()
	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function (xPlayer)
		while ESX == nil do
			Citizen.Wait(0)
		end
		ESX.PlayerData = xPlayer
		PlayerLoaded = true
	end)
end) 

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

end)
---------------------------------------------------------------------------------------------------------------------------------------

--Spawn Storage Unit NPC
Citizen.CreateThread(function()
while true do
    Citizen.Wait(1000)
        local pedCoords = GetEntityCoords(PlayerPedId()) 
        local npcCoords = Config.npcCoords
        local dst = #(npcCoords - pedCoords)
        
        if dst < 30 and npcSpawned == false then
            TriggerEvent('koe_storageunitsv2:spawnPed',npcCoords, Config.npcHeading)
            npcSpawned = true
        end
        if dst >= 31  then
            npcSpawned = false
            DeleteEntity(npc)
        end
end
end)


RegisterNetEvent('koe_storageunitsv2:spawnPed')
AddEventHandler('koe_storageunitsv2:spawnPed',function(coords,heading) 

local hash = GetHashKey(Config.npcModel)
if not HasModelLoaded(hash) then
    RequestModel(hash)
    Wait(10)
end
while not HasModelLoaded(hash) do 
    Wait(10)
end

npc = CreatePed(5, hash, coords, heading, false, false)
FreezeEntityPosition(npc, true)
SetEntityInvincible(npc, true)
SetBlockingOfNonTemporaryEvents(npc, true)
SetModelAsNoLongerNeeded(hash)
exports['qtarget']:AddEntityZone('npc', npc, {
        name="npc",
        debugPoly=false,
        useZ = true
            }, {
            options = {
                {
                event = "koe_storageunitsv2:npcMenu",
                icon = "fa-solid fa-warehouse",
                label = "Storage Unit Menu",
                }                                
            },
                distance = 2.5
            })
end)

RegisterNetEvent('koe_storageunitsv2:npcMenu')
AddEventHandler('koe_storageunitsv2:npcMenu',function(storageID)

    lib.registerContext({
        id = 'npcmenu',
        title = 'Storage Units',
        options = {
            ['Locations'] = {
                description = 'Unowned Locations',
                arrow = true,
                event = '',
                metadata = {'Click to show the location of all unowned units on the map'}
            }
        }
    })
    lib.showContext('npcmenu')

end)

--Qtaret Zones for each storage
Citizen.CreateThread(function()

	local storageConfig = Config.Storages
	for i = 1, #storageConfig, 1 do
    local storageName = storageConfig[1].name
	local length, width = storageConfig[i].bt_length or 0.5, storageConfig[i].bt_width or 0.5
	local minZ, maxZ = storageConfig[i].bt_minZ or 10.0, storageConfig[i].bt_maxZ or 100.0
	local heading = storageConfig[i].bt_heading or 0.0
	local distance = storageConfig[i].bt_distance or 2.0
	local storageid = storageConfig[i].id

	exports['qtarget']:AddBoxZone(i .. storageName, storageConfig[i].coords, length, width, {
		name=i .. storageName,
		heading=heading,
		debugPoly=false,
		minZ=minZ,
		maxZ=maxZ
	}, {
		options = {
			{
				event = "koe_storageunitsv2:checkOwned",
				icon = "fas fa-warehouse",
				label = "Open Storage Unit " .. storageid,
				id = storageid,
                canInteract = function()
                    local player = PlayerPedId()
                    return IsPedOnFoot(player)
                end,
			},
            {
				event = "koe_storageunitsv2:policeBreach",
				icon = "fas fa-warehouse",
				label = "Breach the unit",
				id = storageid,
                job = 'police', 
                canInteract = function()
                    local player = PlayerPedId()
                    return IsPedOnFoot(player)
                end,
            },
		},
		distance = 2.5
	})
        end
end)
   
---Checks the IDs above to then check the status of the storage youre interacting with
RegisterNetEvent('koe_storageunitsv2:checkOwned')
AddEventHandler('koe_storageunitsv2:checkOwned', function(data, balance)
    storageID = data.id
    TriggerServerEvent('koe_storageunitsv2:checkUnit', storageID)
    TriggerServerEvent('koe_storageunitsv2:checkTime', storageID)
end)

--If the storage is NOT owned this menu pops up
RegisterNetEvent('koe_storageunitsv2:buyMenu')
AddEventHandler('koe_storageunitsv2:buyMenu',function(storageID)

    lib.registerContext({
        id = 'buymenu',
        title = 'Storage Units',
        options = {
            ['Purchase Unit'] = {
                description = 'Purchase this unit for $' ..Config.UnitPrice,
                arrow = true,
                event = 'koe_storageunitsv2:buyStorage',
                metadata = {'Purchase with cash'}
            }
        }
    })
    lib.showContext('buymenu')

end)

RegisterNetEvent('koe_storageunitsv2:buyStorage')
AddEventHandler('koe_storageunitsv2:buyStorage', function(data)
    local ox_inventory = exports.ox_inventory
    local count = ox_inventory:Search(2, 'money')
    if count >= Config.UnitPrice then

        local input = lib.inputDialog('Enter a Pin number', {
            { type = "input", label = "UNIT PIN", password = true, icon = 'lock' },
        })

        if input then
            local pin = input[1]

            TriggerServerEvent('koe_storageunitsv2:buyUnit', storageID, pin)
            TriggerServerEvent('koe_storageunitsv2:addTimeToDb', storageID)
            if Config.Notify == 'ox_lib' then
                lib.notify({
                    title = 'Storage Unit',
                    description = 'Unit Purchased',
                    type = 'success',
                    duration = 8000,
                    position = 'top',
                   })
            if Config.Notify == 'swt' then
                exports['swt_notifications']:Success('success','Unit purchased!','top',8000,true)
            end
            if Config.Notify == 'okok' then
                exports['okokNotify']:Alert("Storage Units", "Unit purchased!", 8000, 'success')
            end
            if Config.Notify == 'esx' then
                ESX.ShowNotification('Unit purchased!')
            end
            if Config.Notify == 'custom' then
                --Enter custom code here
            end
        end
    else
        if Config.Notify == 'ox_lib' then
            lib.notify({
                title = 'Storage Unit',
                description = 'Not enough money',
                type = 'error',
                duration = 8000,
                position = 'top',
               })
        if Config.Notify == 'swt' then
            exports['swt_notifications']:Negative('error','Not enough money','top',8000,true)
        end
        if Config.Notify == 'okok' then
            exports['okokNotify']:Alert("Storage Units", "Not enough money", 8000, 'error')
        end
        if Config.Notify == 'esx' then
            ESX.ShowNotification('Not enough money')
        end
        if Config.Notify == 'custom' then
            --Enter custom code here
        end
    end
end)


RegisterNetEvent('koe_storageunitsv2:changePin')
AddEventHandler('koe_storageunitsv2:changePin', function(data)
    local keyboard = lib.inputDialog('Enter your current PIN', {
        { type = "input", label = "Unit PIN", password = true, icon = 'lock' },
    })
    if keyboard[1] ~= nil then
           ESX.TriggerServerCallback('koe_storageunitsv2:checkPin', function(pin)
        if pin then
            local keyboard2 = lib.inputDialog('Enter a NEW PIN', {
                { type = "input", label = "NEW PIN", password = true, icon = 'lock' },
            })

    if keyboard2[1] ~= nil then
        TriggerServerEvent('koe_storageunitsv2:pinChange', storageID,keyboard2[1])
        if Config.Notify == 'ox_lib' then
            lib.notify({
                title = 'Storage Unit',
                description = 'Your pin was changed',
                type = 'success',
                duration = 8000,
                position = 'top',
               })
        if Config.Notify == 'swt' then
            exports['swt_notifications']:Success('success','Your pin was changed!','top',8000,true)
        end
        if Config.Notify == 'okok' then
            exports['okokNotify']:Alert("Storage Units", "Your pin was changed!", 8000, 'success')
        end
        if Config.Notify == 'esx' then
            ESX.ShowNotification('Your pin was changed!')
        end
        if Config.Notify == 'custom' then
            --Enter custom code here
        end
          
    end
        else
            if Config.Notify == 'ox_lib' then
                lib.notify({
                    title = 'Storage Unit',
                    description = 'You have entered the wrong pin.',
                    type = 'error',
                    duration = 8000,
                    position = 'top',
                   })
            if Config.Notify == 'swt' then
		        exports['swt_notifications']:Negative('error','You have entered the wrong pin. ','top',8000,true)
            end
            if Config.Notify == 'okok' then
                exports['okokNotify']:Alert("Storage Units", "You have entered the wrong pin.", 8000, 'error')
            end
            if Config.Notify == 'esx' then
                ESX.ShowNotification('You have entered the wrong pin.')
            end
            if Config.Notify == 'custom' then
                --Enter custom code here
            end
        end
    end, storageID,keyboard[1])
    end

end)


--If the storage IS owned by YOU this menu pops up
RegisterNetEvent('koe_storageunitsv2:ownerMenu')
AddEventHandler('koe_storageunitsv2:ownerMenu',function(storageID, balance)
    rentBalance = balance

    lib.registerContext({
        id = 'ownermenu',
        title = 'Storage Management',
        options = {
            ['Open Storage'] = {
                description = 'Open your storage unit',
                arrow = true,
                event = 'koe_storageunitsv2:registerStash',
                metadata = {'Open this unit'}
            },
            ['Rent Management'] = {
                description = 'Rent Management',
                arrow = true,
                event = 'koe_storageunitsv2:rentMenu',
                metadata = {"Click to manage rent"}
            },
            ['Pin Management'] = {
                description = 'Change your Pin',
                arrow = true,
                event = 'koe_storageunitsv2:changePin',
                metadata = {'You will enter current pin to change it.'}
            },
            ['Sell this unit'] = {
                description = 'Put the unit back on the market',
                arrow = true,
                event = 'koe_storageunitsv2:sellConfirm',
                metadata = {'This will take you to another menu to sell the unit'}
            },
        }
    })
    lib.showContext('ownermenu')
end)

RegisterNetEvent('koe_storageunitsv2:rentMenu')
AddEventHandler('koe_storageunitsv2:rentMenu',function(storageID)

    lib.registerContext({
        id = 'rentmenu',
        title = 'Rent Menu',
        options = {
            ['Rent Balance'] = {
                description = 'You have $'..rentBalance..' in the account',
            },
            ['Add Rent'] = {
                description = 'Add rent to balance',
                arrow = true,
                event = 'koe_storageunitsv2:addBalance',
                metadata = {'Rent cost is ($' ..Config.RentPrice..') its due every week on the date of purchase. Click to add more money'}
            },
            ['Remove Balance'] = {
                description = 'Remove Balance',
                arrow = true,
                event = 'koe_storageunitsv2:removeBalance',
                metadata = {"Click to withdrawl the money in your account"}
            },
        }
    })
    lib.showContext('rentmenu')
end)

RegisterNetEvent('koe_storageunitsv2:addBalance')
AddEventHandler('koe_storageunitsv2:addBalance', function(data)
    local input = lib.inputDialog('Add Balance to rent', {'Rent Amount'})

    if input[1] then
        rent = tonumber(input[1])
            TriggerServerEvent('koe_storageunitsv2:addRentBalance', rent, rentBalance, storageID)
    end
end)

RegisterNetEvent('koe_storageunitsv2:removeBalance')
AddEventHandler('koe_storageunitsv2:removeBalance', function(data)
    local input = lib.inputDialog('Remove Balance from rent', {'Amount'})

    if input[1] then
        amount = tonumber(input[1])
            TriggerServerEvent('koe_storageunitsv2:removeRentBalance', amount, rentBalance, storageID)
    end
end)

RegisterNetEvent('koe_storageunitsv2:registerStash')
AddEventHandler('koe_storageunitsv2:registerStash', function(data)
    local keyboard = lib.inputDialog('Enter your current PIN', {
        { type = "input", label = "Unit PIN", password = true, icon = 'lock' },
    })

    if keyboard[1] ~= nil then
           ESX.TriggerServerCallback('koe_storageunitsv2:checkPin', function(pin)
        if pin then
           TriggerServerEvent('koe_storageunitsv2:registerStash', storageID)
        else
            if Config.Notify == 'ox_lib' then
                lib.notify({
                    title = 'Storage Unit',
                    description = 'You have entered the wrong pin',
                    type = 'error',
                    duration = 8000,
                    position = 'top',
                   })
            if Config.Notify == 'swt' then
		        exports['swt_notifications']:Negative('error','You have entered the wrong pin.','top',8000,true)
            end
            if Config.Notify == 'okok' then
                exports['okokNotify']:Alert("Storage Units", "You have entered the wrong pin.", 8000, 'error')
            end
            if Config.Notify == 'esx' then
                ESX.ShowNotification('You have entered the wrong pin.')
            end
            if Config.Notify == 'custom' then
                --Enter custom code here
            end
        end
    end, storageID,keyboard[1])
    end
end)

RegisterNetEvent('koe_storageunitsv2:openStash')
AddEventHandler('koe_storageunitsv2:openStash', function(stashID)
    TriggerEvent('ox_inventory:openInventory', 'stash', stashID)
    Wait(2000)
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
    TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

RegisterNetEvent('koe_storageunitsv2:sellConfirm')
AddEventHandler('koe_storageunitsv2:sellConfirm',function(storageID)

    lib.registerContext({
        id = 'sellmenu',
        title = 'Sell Unit',
        options = {
            ['Sell Unit'] = {
                description = 'Sell the unit',
                arrow = true,
                event = 'koe_storageunitsv2:storageSell',
                metadata = {'This will sell the unit!'}
            },
        }
    })
    lib.showContext('sellmenu')
end)

RegisterNetEvent('koe_storageunitsv2:storageSell')
AddEventHandler('koe_storageunitsv2:storageSell', function()
    TriggerServerEvent('koe_storageunitsv2:sellUnit', storageID)
    if Config.Notify == 'ox_lib' then
        lib.notify({
            title = 'Storage Unit',
            description = 'You have sold the unit!',
            type = 'success',
            duration = 8000,
            position = 'top',
           })
    if Config.Notify == 'swt' then
        exports['swt_notifications']:Success('success','You sold the unit!','top',8000,true)
    end
    if Config.Notify == 'okok' then
        exports['okokNotify']:Alert("Storage Units", "You sold the unit!", 8000, 'success')
    end
    if Config.Notify == 'esx' then
        ESX.ShowNotification('You sold the unit!')
    end
    if Config.Notify == 'custom' then
        --Enter custom code here
    end
end)

--If the storage IS owned but not by you this menu pops up
RegisterNetEvent('koe_storageunitsv2:otherMenu')
AddEventHandler('koe_storageunitsv2:otherMenu',function(storageID)

    lib.registerContext({
        id = 'othermenu',
        title = 'Owned Storage',
        options = {
            ['Open Storage Unit'] = {
                description = 'Open unit with pin',
                event = 'koe_storageunitsv2:registerStash'
            }
        }
    })
    lib.showContext('othermenu')
end)


RegisterNetEvent('koe_storageunitsv2:policeBreach')
AddEventHandler('koe_storageunitsv2:policeBreach', function(storageID)
    
    for k, v in pairs(Config.Policeraid.Jobs) do
        if v.job == ESX.PlayerData.job.name and ESX.PlayerData.job.grade >= v.grade then
            TriggerServerEvent('koe_storageunitsv2:registerStash', storageID.id)
            TriggerServerEvent('koe_storageunitsv2:breachLog', storageID.id)
        end
    end  
    for k, v in pairs(Config.Policeraid.Jobs) do
        if v.job == ESX.PlayerData.job.name and ESX.PlayerData.job.grade < v.grade then
            if Config.Notify == 'ox_lib' then
                lib.notify({
                    title = 'Storage Unit',
                    description = 'Not a high enough rank to do that.',
                    type = 'error',
                    duration = 8000,
                    position = 'top',
                   })
            if Config.Notify == 'swt' then 
                exports['swt_notifications']:Negative('error','Not a high enough rank to do that.','top',8000,true)
            end
            if Config.Notify == 'okok' then
                exports['okokNotify']:Alert("Storage Units", "Not a high enough rank to do that.", 8000, 'error')
            end
            if Config.Notify == 'esx' then
                ESX.ShowNotification('Not a high enough rank to do that.')
            end
            if Config.Notify == 'custom' then
                --Enter custom code here
            end
        end
    end 
    if ESX.PlayerData.job.name ~= 'police' then
        if Config.Notify == 'ox_lib' then
            lib.notify({
                title = 'Storage Unit',
                description = 'You are not a cop. You cannot do that.',
                type = 'error',
                duration = 8000,
                position = 'top',
               })
        if Config.Notify == 'swt' then
            exports['swt_notifications']:Negative('error','You cant do that, youre not a cop.','top',8000,true)
        end
        if Config.Notify == 'okok' then
            exports['okokNotify']:Alert("Storage Units", "You cant do that, youre not a cop.", 8000, 'error')
        end
        if Config.Notify == 'esx' then
            ESX.ShowNotification('You cant do that, youre not a cop.')
        end
        if Config.Notify == 'custom' then
            --Enter custom code here
        end
    end  
end)
