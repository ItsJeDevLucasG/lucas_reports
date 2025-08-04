ESX = exports["es_extended"]:getSharedObject()

function IsStaff(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local group = xPlayer.getGroup()
    return group ~= "user"
end

function IsStaffInDienst(source)
    return IsStaff(source) and exports['staffdienst']:inDienst(source)
end