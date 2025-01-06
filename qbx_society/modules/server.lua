local Gangs = {}
local Jobs = {}

local function LoadJson(file)
    local jsonData = LoadResourceFile(GetCurrentResourceName(), "data/" .. file .. ".json")
    if jsonData then
        return json.decode(jsonData) or {}
    end
    return {}
end

local function SaveJson(file, data)
    SaveResourceFile(GetCurrentResourceName(), "data/" .. file .. ".json", json.encode(data, { indent = true }), -1)
end

local function LoadData(file, globalTable, globalStateKey)
    local data = LoadJson(file)
    if data then
        _G[globalTable] = data
        GlobalState[globalStateKey] = data
    end
end

local function CheckAndSyncData()
    local jobsFromCore = exports.qbx_core:GetJobs()
    for jobName, _ in pairs(jobsFromCore) do
        if not Jobs[jobName] then
            Jobs[#Jobs + 1] = {
                job = jobName,
                balance = 0,
            }
        end
    end
    GlobalState.Jobs = Jobs
    SaveJson("jobs", Jobs)

    local gangsFromCore = exports.qbx_core:GetGangs()
    for gangName, _ in pairs(gangsFromCore) do
        if not Gangs[gangName] then
            Gangs[#Gangs + 1] = {
                gang = gangName,
                balance = 0,
            }
        end
    end
    GlobalState.Gangs = Gangs
    SaveJson("gangs", Gangs)
end

local function GetTableAndFile(type)
    if type == "job" then
        return Jobs, "jobs"
    elseif type == "gang" then
        return Gangs, "gangs"
    else
        return nil, nil
    end
end

function GetMoney(type, name)
    local dataTable = GetTableAndFile(type)
    if not dataTable then return 0 end

    for _, entry in pairs(dataTable) do
        if entry.job == name or entry.gang == name then
            return entry.balance or 0
        end
    end
    return 0
end

exports('GetMoney', GetMoney)

function AddMoney(type, name, amount)
    local dataTable, file = GetTableAndFile(type)
    if not dataTable then return false end

    for _, entry in pairs(dataTable) do
        if entry.job == name or entry.gang == name then
            entry.balance = (entry.balance or 0) + amount
            SaveJson(file, dataTable)
            return true
        end
    end
    return false
end

exports('AddMoney', AddMoney)

function RemoveMoney(type, name, amount)
    local dataTable, file = GetTableAndFile(type)
    if not dataTable then return false end

    for _, entry in pairs(dataTable) do
        if entry.job == name or entry.gang == name then
            if (entry.balance or 0) >= amount then
                entry.balance = entry.balance - amount
                SaveJson(file, dataTable)
                return true
            else
                return false 
            end
        end
    end
    return false
end

exports('RemoveMoney', RemoveMoney)

function HasBalance(type, name, amount)
    local dataTable = GetTableAndFile(type)
    if not dataTable then return false end

    for _, entry in pairs(dataTable) do
        if entry.job == name or entry.gang == name then
            return (entry.balance or 0) >= amount
        end
    end
    return false
end

exports('HasBalance', HasBalance)

AddEventHandler("onServerResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CheckAndSyncData()
        LoadData("gangs", "Gangs", "Gangs")
        LoadData("jobs", "Jobs", "Jobs")
    end
end)

--[[
    -- Get the balance for a job
    local balance = exports.qbx_society:GetMoney("job", "police") 
    print("Police job balance: $" .. balance)

    -- Get the balance for a gang
    local gangBalance = exports.qbx_society:GetMoney("gang", "ballas")
    print("Ballas gang balance: $" .. gangBalance)

    -- Add $1000 to the police job balance
    local success = exports.qbx_society:AddMoney("job", "police", 1000)
    if success then
        print("Successfully added money to the police balance!")
    else
        print("Failed to add money to the police balance.")
    end

    -- Deduct $500 from Ballas gang balance
    local success = exports.qbx_society:RemoveMoney("gang", "ballas", 500)
    if success then
        print("Successfully subtracted money from the Ballas balance!")
    else
        print("Insufficient funds or failed to subtract.")
    end

    -- Check if the police job has sufficient funds
    local hasFunds = exports.qbx_society:HasBalance("job", "police", 1500)
    if hasFunds then
        print("Police job has sufficient funds.")
    else
        print("Police job does not have enough funds.")
    end
]]
