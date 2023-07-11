local storageData, myId = {}, nil;
CreateThread(function()
    for i = 1, #Config.StorageLocations do
        local canInteract = function()
            local storage = tonumber(storageData[i]);
            if storage ~= nil then
                return storage == myId;
            end
        end
        local unit = Config.StorageLocations[i];
        local target = Config.Target;
        if target == 'qtarget' or target == 'qb-target' then
            
        elseif target == 'ox_target' then
            exports['ox_target']:addBoxZone({
                coords = unit.location,
                rotation = unit.heading,
                debug = unit.debug or false,
                size = unit.size or vec3(5, 2, 3),
                options = {
                    {
                        label = 'Open Stash',
                        icon = 'fas fa-box-open',
                        onSelect = function()
                            exports.ox_inventory:openInventory('stash', { id = 'ec_storages_storage_'..i })
                        end,
                        canInteract = canInteract,
                        distance = unit.distance or 2.5
                    },
                    {
                        label = 'Buy Storage',
                        icon = 'fas fa-box-open',
                        onSelect = function()
                            local alert = lib.alertDialog({
                                header = 'Do you want to buy this storage?',
                                content = 'Price: $'..Config.StorageTypes[unit.type].price,
                                centered = true,
                                cancel = true
                            }); if alert == 'confirm' then
                                TriggerServerEvent('ec-storages:server:buyStorage', i, Config.StorageTypes[unit.type].price);
                            end
                        end,
                        canInteract = function()
                            return storageData[i] == nil;
                        end,
                        distance = unit.distance or 2.5
                    }
                }
            })
        end
    end
    -- Storage Oweners --
    lib.callback('ec-storages:server:getData', false, function(data, id)
        storageData, myId = data, id;
    end);
end);

RegisterNetEvent('ec-storages:client:forceUpdateStorageData', function()
    lib.callback('ec-storages:server:getData', false, function(data, id)
        storageData, myId = data, id;
    end);
end);