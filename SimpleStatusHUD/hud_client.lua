ESX = exports["es_extended"]:getSharedObject()
local food, water, stress
local hudVisible = true

AddEventHandler("esx_status:onTick", function(data)
    for i = 1, #data do
        if data[i].name == "hunger" then
            food = math.max(0, math.min(100, math.floor(data[i].percent)))
        elseif data[i].name == "thirst" then
            water = math.max(0, math.min(100, math.floor(data[i].percent)))
        elseif data[i].name == "stress" then
            stress = math.max(0, math.min(100, math.floor(data[i].percent)))
        end
    end
end)

RegisterCommand('hidehud', function()
    hudVisible = not hudVisible
    if hudVisible then
        SendNUIMessage({ display = true })
    else
        SendNUIMessage({ display = false })
    end
end, false)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        SendNUIMessage({
            pauseMenu = IsPauseMenuActive(),
            health = GetEntityHealth(PlayerPedId())-100,
            armour = GetPedArmour(PlayerPedId()),
            stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
            food = food,
            water = water,
            stress = stress,
        })
    end
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(false, false)
    while true do
        DisplayRadar(false)
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)