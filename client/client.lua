local QRCore = exports['qr-core']:GetCoreObject()
local active = false
local amount = 0
local cooldown = 0
local oldBush = {}
local checkbush = 0
local bush
local itemname
local amount

Citizen.CreateThread(function()
    Wait(2000)
    while true do
        Wait(1)
        local playerped = PlayerPedId()
        if checkbush < GetGameTimer() and not IsPedOnMount(playerped) and not IsPedInAnyVehicle(playerped) and not eat and cooldown < 1 then
            bush = GetClosestBush()
            checkbush = GetGameTimer() + 500
        end
        if bush then
            if IsControlPressed(0, `INPUT_INTERACT_OPTION1`) then
                active = false
                oldBush[tostring(bush)] = true
                goCollect()
            end
        end
    end
end)

function GetClosestBush()
    local entity=false
    for k,v in pairs(Config.gathering) do
        Wait(100)
        local playerped = PlayerPedId()
        local itemSet = CreateItemset(true)
        local size = Citizen.InvokeNative(0x59B57C4B06531E1E, GetEntityCoords(playerped), 2.0, itemSet, 3, Citizen.ResultAsInteger())
        if size > 0 then
            for index = 0, size - 1 do
                local entity = GetIndexedItemInItemset(index, itemSet)
                local model_hash = GetEntityModel(entity)
                if (model_hash ==  v.model) and not oldBush[tostring(entity)] then
                    if IsItemsetValid(itemSet) then
                    DestroyItemset(itemSet)
                    itemname = v.item
                    amount = v.amount
                    print("K  :"..k)
                    print("V  : "..v.amount)
                    print("Amount  :"..amount)
                end
                return entity
                end
            end
        else
        end

        if IsItemsetValid(itemSet) then
            DestroyItemset(itemSet)
        end
    end 
end



function goCollect()
    local playerPed = PlayerPedId()
    print("amount 2 :" ..amount)
    RequestAnimDict("mech_pickup@plant@berries")
    while not HasAnimDictLoaded("mech_pickup@plant@berries") do
        Wait(100)
    end
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "enter_lf", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(800)
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "base", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(2300)
    TriggerServerEvent('tcrp_gathering:additem', itemname, amount)
    print(itemname)
    active = false
    ClearPedTasks(playerPed)
end