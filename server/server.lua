local QRCore = exports['qr-core']:GetCoreObject()

RegisterServerEvent('tcrp_gathering:additem')
AddEventHandler('tcrp_gathering:additem', function(itemname, amount) 
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	print(amount)
	Player.Functions.AddItem(itemname, amount)
	TriggerClientEvent('inventory:client:ItemBox', src, QRCore.Shared.Items[itemname], "add")
end)
