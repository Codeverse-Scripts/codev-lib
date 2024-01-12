local Framework = nil

function Codev.Functions.GetJsonData(resource, name)
    local data = LoadResourceFile(resource, name)
    if not data then
        print("CODEV: " .. name .. " not found.")
        return
    end
    local decodedData = json.decode(data)
    return decodedData
end

function Codev.Functions.SaveJsonData(resource, name, data)
    SaveResourceFile(resource, name, json.encode(data), -1)
end

-- FRAMEWORK SPECIFIC FUNCTIONS --
function Codev.Functions.GetCoreObject()
    local timeOut = 3000

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

function Codev.Functions.GetPlayer(src)
    if not Framework then return end

    if CODEV.Framework == "qb" then
        local player = Framework.Functions.GetPlayer(src)
        return player
    elseif CODEV.Framework == "esx" then
        local player = Framework.GetPlayerFromId(src)
        return player
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.GetPlayerFromLicense(license)
    if not Framework then return end

    if CODEV.Framework == "qb" then
        local player = Framework.Functions.GetPlayerByLicense(license)
        return player
    elseif CODEV.Framework == "esx" then
        local player = Framework.GetPlayerByLicense(license)
        return player
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.GetMoney(src, type)
    if not Framework then return end
    local timeOut = 3000

    local player = Codev.Functions.GetPlayer(src)
    local type = type or "cash"

    while not player do
        Citizen.Wait(100)
        timeOut = timeOut - 100
        print("CODEV: Waiting for player.")
        player = Codev.Functions.GetPlayer(src)
        if timeOut <= 0 then
            print("CODEV: Timeout while waiting for player.")
            return
        end
    end

    if CODEV.Framework == "qb" then
        local money = player.Functions.GetMoney(type)
        return money
    elseif CODEV.Framework == "esx" then
        local money = player.getAccount(type).money
        return money
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.AddMoney(src, mtype, amount, reason)
    if not Framework then return end
    local timeOut = 3000

    local player = Codev.Functions.GetPlayer(src)
    local mtype = mtype or "cash"
    local reason = reason or "Unknown"
    local amount = amount or 0

    while not player do
        Citizen.Wait(100)
        timeOut = timeOut - 100
        print("CODEV: Waiting for player.")
        player = Codev.Functions.GetPlayer(src)
        if timeOut <= 0 then
            print("CODEV: Timeout while waiting for player.")
            return false
        end
    end

    if CODEV.Framework == "qb" then
        player.Functions.AddMoney(mtype, amount, reason)
    elseif CODEV.Framework == "esx" then
        player.addAccountMoney(mtype, amount)
    else
        print("CODEV: Framework not found.")
    end

    return true
end

function Codev.Functions.RemoveMoney(src, type, amount, reason)
    if not Framework then return end
    local timeOut = 3000

    local player = Codev.Functions.GetPlayer(src)

    while not player do
        Citizen.Wait(100)
        timeOut = timeOut - 100
        print("CODEV: Waiting for player.")
        player = Codev.Functions.GetPlayer(src)
        if timeOut <= 0 then
            print("CODEV: Timeout while waiting for player.")
            return false
        end
    end

    local type = type or "cash"
    local reason = reason or "Unknown"
    local playerMoney = Codev.Functions.GetMoney(src, type)

    if playerMoney < amount then
        print("CODEV: Player does not have enough money.")
        return false
    end

    if CODEV.Framework == "qb" then
        player.Functions.RemoveMoney(type, amount, reason)
    elseif CODEV.Framework == "esx" then
        player.removeAccountMoney(type, amount)
    else
        print("CODEV: Framework not found.")
    end

    return true
end

function Codev.Functions.HasItem(src, item, amount)
    if not Framework then return end
    local timeOut = 3000
    
    local player = Codev.Functions.GetPlayer(src)
    local amount = amount or 1

    while not player do
        Citizen.Wait(100)
        timeOut = timeOut - 100
        print("CODEV: Waiting for player.")
        player = Codev.Functions.GetPlayer(src)
        if timeOut <= 0 then
            print("CODEV: Timeout while waiting for player.")
            return
        end
    end

    if CODEV.Framework == "qb" then
        local item = player.Functions.GetItemByName(item)
        if item ~= nil and item.amount >= amount then
            return true
        else
            return false
        end
    elseif CODEV.Framework == "esx" then
        local item = player.getInventoryItem(item)
        if item ~= nil and item.count >= amount then
            return true
        else
            return false
        end
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.AddItem(src, item, amount)
    if not Framework then return end
    local timeOut = 3000

    local player = Codev.Functions.GetPlayer(src)
    local amount = amount or 1

    while not player do
        Citizen.Wait(100)
        timeOut = timeOut - 100
        print("CODEV: Waiting for player.")
        player = Codev.Functions.GetPlayer(src)
        if timeOut <= 0 then
            print("CODEV: Timeout while waiting for player.")
            return
        end
    end

    if CODEV.Framework == "qb" then
        player.Functions.AddItem(item, amount)
    elseif CODEV.Framework == "esx" then
        player.addInventoryItem(item, amount)
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.RemoveItem(src, item, amount)
    if not Framework then return end
    local timeOut = 3000

    local player = Codev.Functions.GetPlayer(src)
    local amount = amount or 1

    while not player do
        Citizen.Wait(100)
        timeOut = timeOut - 100
        print("CODEV: Waiting for player.")
        player = Codev.Functions.GetPlayer(src)
        if timeOut <= 0 then
            print("CODEV: Timeout while waiting for player.")
            return
        end
    end

    if Codev.Functions.HasItem(src, item, amount) == false then
        print("CODEV: Player does not have enough of this item.")
        return
    end

    if CODEV.Framework == "qb" then
        player.Functions.RemoveItem(item, amount)
    elseif CODEV.Framework == "esx" then
        player.removeInventoryItem(item, amount)
    else
        print("CODEV: Framework not found.")
    end
end

function Codev.Functions.GetPlayerInventory(src)
    if not Framework then return end
    local timeOut = 3000
    local itemlist = {}

    local player = Codev.Functions.GetPlayer(src)

    while not player do
        Citizen.Wait(100)
        timeOut = timeOut - 100
        print("CODEV: Waiting for player.")
        player = Codev.Functions.GetPlayer(src)
        if timeOut <= 0 then
            print("CODEV: Timeout while waiting for player.")
            return
        end
    end

    if CODEV.Framework == "qb" then
        for k,v in pairs(player.PlayerData.items) do
            itemlist[k-1] = {
                count = v.amount,
                label = v.label,
                image = v.image,
                name = v.name,
            }
        end
    elseif CODEV.Framework == "esx" then
        for k,v in pairs(player.inventory) do
            itemlist[k-1] = {
                count = v.count,
                label = v.label,
                image = v.image,
                name = v.name,
            }
        end
    else
        print("CODEV: Framework not found.")
    end

    return itemlist
end

-- MYSQL SPECIFIC FUNCTIONS --
function Codev.Functions.MysqlQuery(query, params)
    local timeOut = 3000

	if CODEV.MySQL == "oxmysql" then
        while not GetResourceState("oxmysql") == "started" do
            Citizen.Wait(100)
            timeOut = timeOut - 100
            print("CODEV: Waiting for oxmysql.")
            if timeOut <= 0 then
                print("CODEV: Timeout while waiting for oxmysql.")
                return
            end
        end

		return exports["oxmysql"]:query_async(query, params)
	elseif CODEV.MySQL == "mysql-async" then
        while not GetResourceState("mysql-async") == "started" do
            Citizen.Wait(100)
            timeOut = timeOut - 100
            print("CODEV: Waiting for mysql-async.")
            if timeOut <= 0 then
                print("CODEV: Timeout while waiting for mysql-async.")
                return
            end
        end

		local p = promise.new()

		exports['mysql-async']:mysql_execute(query, params, function(result)
			p:resolve({ result })
		end)

		return Citizen.Await(p)
	elseif CODEV.MySQL == "ghmattimysql" then
        while not GetResourceState("ghmattimysql") == "started" do
            Citizen.Wait(100)
            timeOut = timeOut - 100
            print("CODEV: Waiting for ghmattimysql.")
            if timeOut <= 0 then
                print("CODEV: Timeout while waiting for ghmattimysql.")
                return
            end
        end

		return exports['ghmattimysql']:executeSync(query, params)
	end
end