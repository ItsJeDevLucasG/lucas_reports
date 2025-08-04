RegisterNetEvent('lucas:reports:sendNotify')
AddEventHandler('lucas:reports:sendNotify', function(notifyType, notifyDescription)
    lib.notify({ type = notifyType, title = 'Reports', description = notifyDescription })
end)

RegisterNetEvent('lucas:reports:sendChat')
AddEventHandler('lucas:reports:sendChat', function(text)
    exports['chat']:SendChatMessage(text, 'Reports', 'staffchat')
end)