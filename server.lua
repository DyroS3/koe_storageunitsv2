discord = {
  ['webhook'] = '',  ---PUT YOUR WEBHOOK URL HERE
  ['name'] = 'Storage Units'
}


----Gets ESX-----
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('koe_storageunitsv2:checkUnit')
AddEventHandler('koe_storageunitsv2:checkUnit', function(storageID, balance)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier

    MySQL.Async.fetchAll('SELECT * FROM storageunits WHERE id = @id',
    { 
      ['@identifier'] = owner,
      ['@id'] = storageID,
      ['@balance'] = balance
    }, 
    function(result)
      local balance = result[1].balance

        if result[1].identifier == nil then
          TriggerClientEvent('koe_storageunitsv2:buyMenu', src, storageID, balance)
        elseif result[1].identifier == identifier then
          TriggerClientEvent('koe_storageunitsv2:ownerMenu', src, storageID, balance)
        else
          TriggerClientEvent('koe_storageunitsv2:otherMenu', src, storageID, balance)
        end
    end)
end)

RegisterNetEvent('koe_storageunitsv2:addTimeToDb')
AddEventHandler('koe_storageunitsv2:addTimeToDb', function(storageID)
  local time = os.time()

  MySQL.Async.fetchAll("UPDATE storageunits SET time = @time WHERE id =@id",{['@time']  = time, ['@id'] = storageID}, function(result)
  end)
end)

RegisterNetEvent('koe_storageunitsv2:checkTime')
AddEventHandler('koe_storageunitsv2:checkTime', function(storageID, time)
  local currentTime = os.time()

  for k, v in pairs (Config.Storages) do
    MySQL.Async.fetchAll('SELECT * FROM storageunits WHERE id = @id',{['@id'] = v.id}, function(result)

      for _ , t in pairs(result) do
          local currentBalance = t.balance
          local savedTime = t.time
          local timeCheck = savedTime - currentTime 
          local rentTime  = -604800 --(-604800 = 1 week in seconds)--------------------------

          --Checks the balance of the unit, if after 1 week has passed then it will remove the amount defined in the Config (Config.RentPrice)
          if currentBalance >= Config.RentPrice then
            if timeCheck <= rentTime then
              local newBalance = t.balance - Config.RentPrice
              MySQL.Async.fetchAll("UPDATE storageunits SET balance = @balance WHERE id =@id",{['@balance']  = newBalance, ['@id'] = v.id}, function(result)
              end) 
              TriggerEvent('koe_storageunitsv2:addTimeToDb',storageID)
            end
          end

          --If the balance of the unit is 0 or less it will set the balance to 0 and remove the owner of the unit
          if currentBalance <= 0 and timeCheck <= rentTime then
              MySQL.Async.fetchAll("UPDATE storageunits SET balance = @balance WHERE id =@id",{['@balance']  = 0, ['@id'] = v.id}, function(result)
              end)
              MySQL.Async.fetchAll("UPDATE storageunits SET identifier = @identifier WHERE id =@id",{['@identifier']  = nil, ['@id'] = v.id}, function(result)
              end)
              MySQL.Async.fetchAll("UPDATE storageunits SET time = @time WHERE id =@id",{['@time']  = 0, ['@id'] = v.id}, function(result)
              end)
          end
      end

    end)
  end

end)

ESX.RegisterServerCallback('koe_storageunitsv2:checkPin', function(source, cb, storageID, pinnum)
 MySQL.Async.fetchAll("SELECT pin FROM storageunits WHERE id = @id",{
    ["@id"] = storageID,
 },
function(result)
        if result[1].pin == pinnum then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent('koe_storageunitsv2:pinChange')
AddEventHandler('koe_storageunitsv2:pinChange', function(storageID,balance)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier
               MySQL.Async.fetchAll("UPDATE storageunits SET pin = @pin WHERE id =@id",{['@pin']  = pin, ['@id'] = storageID}, function(result)
            end)
end)

RegisterNetEvent('koe_storageunitsv2:addRentBalance')
AddEventHandler('koe_storageunitsv2:addRentBalance', function(rent, balance, storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local newRent = rent + balance

    if xPlayer.getMoney() >= tonumber(rent) then 
      MySQL.Async.fetchAll("UPDATE storageunits SET balance = @balance WHERE id =@id",{['@balance']  = newRent, ['@id'] = storageID}, function(result)
        xPlayer.removeMoney(rent)

        if Config.Notify == 'ox_lib' then
            TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = "You've added some money to your rent balance", duration = 8000, position = 'top'})
        if Config.Notify == 'swt' then
            TriggerClientEvent("swt_notifications:default",src,'You've added some money to your rent balance','top',8000)
        end
        if Config.Notify == 'okok' then
            TriggerClientEvent('okokNotify:Alert', src, "Storage Units", "You've added some money to your rent balance", 8000, 'success')
        end
        if Config.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', src, 'You've added some money to your rent balance')
        end
        if Config.Notify == 'custom' then
            --Enter custom code here
        end
        
      end)
    else
      if Config.Notify == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = "Not enough cash", duration = 8000, position = 'top'})
      if Config.Notify == 'swt' then
        TriggerClientEvent("swt_notifications:default",src,'Not enough cash','top',8000)
      end
      if Config.Notify == 'okok' then
          TriggerClientEvent('okokNotify:Alert', src, "Storage Units", "Not enough cash", 8000, 'error')
      end
      if Config.Notify == 'esx' then
          TriggerClientEvent('esx:showNotification', src, 'Not enough cash')
      end
      if Config.Notify == 'custom' then
          --Enter custom code here
      end
    end

end)

RegisterNetEvent('koe_storageunitsv2:removeRentBalance')
AddEventHandler('koe_storageunitsv2:removeRentBalance', function(amount, balance, storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local adjustedAmount = balance - amount

    if balance >= amount then 
      MySQL.Async.fetchAll("UPDATE storageunits SET balance = @balance WHERE id =@id",{['@balance']  = adjustedAmount, ['@id'] = storageID}, function(result)
        xPlayer.addMoney(amount)

        if Config.Notify == 'ox_lib' then
          TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = "You took out $", duration = 8000, position = 'top'})
        if Config.Notify == 'swt' then
            TriggerClientEvent("swt_notifications:default",src,'you took out $' ..amount,'top',8000)
        end
        if Config.Notify == 'okok' then
            TriggerClientEvent('okokNotify:Alert', src, "Storage Units", 'you took out $' ..amount , 8000, 'success')
        end
        if Config.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', src, 'you took out $' ..amount)
        end
        if Config.Notify == 'custom' then
            --Enter custom code here
        end
        
      end)
    else
      if Config.Notify == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = "Not enough in account.", duration = 8000, position = 'top'})
      if Config.Notify == 'swt' then
        TriggerClientEvent("swt_notifications:default",src,'Not enough in account','top',8000)
      end
      if Config.Notify == 'okok' then
          TriggerClientEvent('okokNotify:Alert', src, "Storage Units", "Not enough in account", 8000, 'error')
      end
      if Config.Notify == 'esx' then
          TriggerClientEvent('esx:showNotification', src, 'Not enough in account')
      end
      if Config.Notify == 'custom' then
          --Enter custom code here
      end
    end

end)

RegisterNetEvent('koe_storageunitsv2:buyUnit')
AddEventHandler('koe_storageunitsv2:buyUnit', function(storageID,pin)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier

    MySQL.Async.fetchAll('SELECT * FROM storageunits WHERE id = @id',
    { 
      ['@identifier'] = owner,
      ['@id'] = storageID
    },
    function(result2) 

            if xPlayer.getMoney() >= Config.UnitPrice then
              MySQL.Async.fetchAll("UPDATE storageunits SET identifier = @identifier WHERE id =@id",{['@identifier']  = identifier, ['@id'] = storageID}, function(result)
                xPlayer.removeMoney(Config.UnitPrice)
              end)
               MySQL.Async.fetchAll("UPDATE storageunits SET pin = @pin WHERE id =@id",{['@pin']  = pin, ['@id'] = storageID}, function(result)
              end)
            end

    end) 
end)

RegisterNetEvent('koe_storageunitsv2:sellUnit')
AddEventHandler('koe_storageunitsv2:sellUnit', function(storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll('SELECT * FROM storageunits WHERE id = @id',
    { 
      ['@identifier'] = owner,
      ['@id'] = storageID
    }, 
    function(result2) 
    
              MySQL.Async.fetchAll("UPDATE storageunits SET identifier = @identifier, pin = @pin, time = @time WHERE id =@id",{['@identifier']  = identifier, ['@id'] = storageID, ['@pin'] = pin, ['@time'] = 0}, function(result)
                xPlayer.addMoney(Config.SellPrice)
              end)
    end)
end)

RegisterNetEvent('koe_storageunitsv2:registerStash')
AddEventHandler('koe_storageunitsv2:registerStash', function(storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier

    MySQL.Async.fetchAll('SELECT id FROM storageunits WHERE id = @id',
    { 
      ['@id'] = storageID
    }, 
    function(result3)
        stashID = json.encode(result3)
        exports.ox_inventory:RegisterStash(stashID, "Storage Unit", 70, 300000)
        TriggerClientEvent('koe_storageunitsv2:openStash', src, stashID)
    end)
end)

RegisterNetEvent('koe_storageunitsv2:breachLog')
AddEventHandler('koe_storageunitsv2:breachLog', function(storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    discordLog(xPlayer.getName() ..  ' - ' .. xPlayer.getIdentifier(), 'has breached the unit #' ..storageID)
end)

function discordLog(name, message)
  local data = {
      {
          ["color"] = '3553600',
          ["title"] = "**".. name .."**",
          ["description"] = message,
      }
  }
  PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data}), { ['Content-Type'] = 'application/json' })
end
