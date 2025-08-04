RegisterNetEvent('lucas:reports:sendChat')
AddEventHandler('lucas:reports:sendChat', function(text)
    exports['chat']:SendChatMessage(text, 'Reports', 'staffchat')
end)