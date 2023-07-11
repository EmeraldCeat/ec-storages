Config = {};

-- Configuration --

Config.Target = 'ox_target'; -- qtarget, ox_target, or qb-target
Config.StorageTypes = {
    ['small'] = { slots = 25, weight = 250, price = 2500 },
    ['medium'] = { slots = 50, weight = 500, price = 5000 },
    ['large'] = { slots = 100, weight = 1000, price = 7500 }
};

Config.StorageLocations = {
    [1] = {
        location = vec3(-72.32, -1233.81, 29.08),
        size = vec3(5, 2, 3),
        type = 'small', heading = 55.00, debug = false
    }, [2] = {
        location = vec3(-66.1092, -1239.2352, 29.0321),
        size = vec3(5, 2, 3),
        type = 'small', heading = 227.50, debug = false
    }
};