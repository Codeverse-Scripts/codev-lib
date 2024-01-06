local Framework = nil

function Codev.Functions.DrawText(text, x, y, scale, font, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function Codev.Functions.GetEntityCoords(ped)
    local coords = GetEntityCoords(ped)
    return vector4(coords.x, coords.y, coords.z, GetEntityHeading(ped))
end

function Codev.Functions.PlayAnim(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
end

function Codev.Functions.RequestAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

function Codev.Functions.LoadModel(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

function Codev.Functions.CreateVehicle(hash, x, y, z, h, isnetwork, setpedin)
    Codev.Functions.LoadModel(hash)
    local vehicle = CreateVehicle(hash, x, y, z, h, isnetwork, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleLivery(vehicle, 1)
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleOnGroundProperly(vehicle)
    if setpedin then SetPedIntoVehicle(PlayerPedId(), vehicle, -1) end
    return vehicle
end

function Codev.Functions.CreatePed(hash, x, y, z, h, isnetwork, invincible, freeze)
    Codev.Functions.LoadModel(hash)
    local ped = CreatePed(4, hash, x, y, z, h, isnetwork, true)
    SetEntityInvincible(ped, invincible)
    FreezeEntityPosition(ped, freeze)
    return ped
end

function Codev.Functions.GetPlayers()
    local players = {}
    local pool = GetGamePool("CPed")

    for _, ped in ipairs(pool) do
        if not IsPedAPlayer(ped) then goto continue end
        table.insert(players, ped)
        ::continue::
    end

    return players
end

function Codev.Functions.GetPeds()
    return GetGamePool("CPed")
end

function Codev.Functions.GetClosestPlayer(ped)
    if ped == nil then ped = PlayerPedId() end

    local players = Codev.Functions.GetPlayers()
    local closestDistance = -1
    local closestPed = nil

    for _, player in ipairs(players) do
        if player == ped then goto continue end
        local distance = #(GetEntityCoords(ped) - GetEntityCoords(player))
        if closestDistance == -1 or distance < closestDistance then
            closestDistance = distance
            closestPed = player
        end
        ::continue::
    end

    return closestPed
end

function Codev.Functions.GetClosestPed(ped)
    if ped == nil then ped = PlayerPedId() end

    local players = Codev.Functions.GetPeds()
    local closestDistance = -1
    local closestPed = nil

    for _, player in ipairs(players) do
        if player == ped then goto continue end
        local distance = #(GetEntityCoords(ped) - GetEntityCoords(player))
        if closestDistance == -1 or distance < closestDistance then
            closestDistance = distance
            closestPed = player
        end
        ::continue::
    end

    return closestPed
end

function Codev.Functions.GetClosestVehicle(ped)
    if ped == nil then ped = PlayerPedId() end

    local vehicles = GetGamePool("CVehicle")
    local closestDistance = -1
    local closestVehicle = nil

    for _, vehicle in ipairs(vehicles) do
        local distance = #(GetEntityCoords(ped) - GetEntityCoords(vehicle))
        if closestDistance == -1 or distance < closestDistance then
            closestDistance = distance
            closestVehicle = vehicle
        end
    end

    return closestVehicle
end

function Codev.Functions.GetGameTime()
    local obj = {}
    obj.min = GetClockMinutes()
    obj.hour = GetClockHours()

    if obj.hour <= 12 then
        obj.ampm = "AM"
    elseif obj.hour >= 13 then
        obj.ampm = "PM"
        obj.formattedHour = obj.hour - 12
    end

    if obj.min <= 9 then
        obj.formattedMin = "0" .. obj.min
    end

    return obj
end

-- FRAMEWORK SPECIFIC FUNCTIONS --
function Codev.Functions.GetCoreObject()
    local timeOut = 5000

    if CODEV.Framework == "qb" then
        while not GetResourceState("qb-core") == "started" do
            Citizen.Wait(100)
            timeOut = timeOut - 100
            print("CODEV: Waiting for qb-core.")
            if timeOut <= 0 then
                print("CODEV: Timeout while waiting for qb-core.")
                return
            end
        end

        Framework = exports["qb-core"]:GetCoreObject()
        return Framework
    elseif CODEV.Framework == "esx" then
        while not GetResourceState("es_extended") == "started" do
            Citizen.Wait(100)
            timeOut = timeOut - 100
            print("CODEV: Waiting for es_extended.")
            if timeOut <= 0 then
                print("CODEV: Timeout while waiting for es_extended.")
                return
            end
        end

        Framework = exports["es_extended"]:getSharedObject()
        return Framework
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.GetPlayerData()
    if not Framework then return end

    if CODEV.Framework == "qb" then
        local playerData = Framework.Functions.GetPlayerData()
        return playerData
    elseif CODEV.Framework == "esx" then
        local playerData = Framework.GetPlayerData()
        return playerData
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.TriggerCallback(...)
    if not Framework then return end

    if CODEV.Framework == "qb" then
        Framework.Functions.TriggerCallback(...)
    elseif CODEV.Framework == "esx" then
        Framework.TriggerServerCallback(...)
    else
        print("CODEV: Framework not found.")
    end
end