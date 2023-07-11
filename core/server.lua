local esx, qbcore = GetResourceState('es_extended'):find('start'), GetResourceState('qb-core'):find('start');
local core = nil;
if esx then
    core = esx:getSharedObject();
elseif qbcore then
    core = qbcore:GetCoreObject();
else
    local file = ('imports/%s.lua'):format(IsDuplicityVersion() and 'server' or 'client');
    local import = LoadResourceFile('ox_core', file);
    local chunk = assert(load(import, ('@@ox_core/%s'):format(file)));
    chunk();
end

CreateThread(function()
    for i = 1, #Config.StorageLocations do
        local id = 'ec_storages_storage_'..i;
        local label = 'Starge '..i;
        local type = Config.StorageLocations[i].type;
        local slots = Config.StorageTypes[type].slots;
        local weight = Config.StorageTypes[type].weight;
        exports['ox_inventory']:RegisterStash(id, label, slots, weight, false)
    end
end);

---@param src number
---@return table, number | string
lib.callback.register('ec-storages:server:getData', function(src)
    -- Id Getting --
    local myId = nil;
    if core then
        if esx then
            myId = core.GetPlayerFromId(src).identifier;
        elseif qbcore then
            myId = core.Functions.GetPlayer(src).citizenid;
        end
    else
        myId = Ox.GetPlayer(src).userid;
    end
    -- Owner Getting --
    local data = {};
    local result = MySQL.query.await('SELECT * FROM storage_units');
    if result then
        for i = 1, #result do
            local row = result[i];
            data[row.stash_id] = row.owner;
        end
    end
    return data, myId;
end);

---@param id number
---@param price number
---@return nil
RegisterServerEvent('ec-storages:server:buyStorage', function(id, price)
    local src = source;
    -- Money Removing --
    local cash = exports['ox_inventory']:GetItemCount(src, 'cash');
    if cash < price then
        print('not enough money')
        return;
    end
    exports['ox_inventory']:RemoveItem(src, 'cash', price);
    -- Id Getting --
    local myId = nil;
    if core then
        if esx then
            myId = core.GetPlayerFromId(src).identifier;
        elseif qbcore then
            myId = core.Functions.GetPlayer(src).citizenid;
        end
    else
        myId = Ox.GetPlayer(src).userid;
    end
    -- Owner Setting --
    MySQL.query('SELECT * FROM storage_units WHERE stash_id = ?', {
        id
    }, function(result)
        local func, query = MySQL.update, 'UPDATE storage_units SET owner = ? WHERE stash_id = ?';
        if not result or not result?[1] then
            func, query = MySQL.insert, 'INSERT INTO storage_units (owner, stash_id) VALUES (?, ?)';
        end
        func(query, { myId, id });
    end);
    TriggerClientEvent('ec-storages:client:forceUpdateStorageData', -1);
end);