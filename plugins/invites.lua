local PLUGIN = PLUGIN
PLUGIN.name = "Invites"
PLUGIN.author = "Mobious"
PLUGIN.description = "Whitelists server, allowing people to invite other"

function PLUGIN:LoadData()
	PLUGIN.invites = self:GetData() or {}
end

function PLUGIN:SaveData()
	self:SetData(PLUGIN.invites)
end

if (SERVER) then
    --PLUGIN.invites["STEAM_0:0:31051054"] = 1
    gameevent.Listen("player_connect")
    hook.Add("player_connect", "checkInvites", function(data)
        local steamID = data.networkid
        if (PLUGIN.invites[steamID] == nil) then
            game.KickID(steamID, "Извините! Вы должны быть приглашены другом через /invite")
        end
    end)
end

ix.command.Add("invite", {
	description = "Дает право игроку по STEAM_0: STEAM_ID присоединяться к серверу",
	superAdminOnly = false,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, STEAM_0)
		if (PLUGIN.invites[STEAM_0] != nil) then
            client:notify("Игрок уже имеет доступ к серверу")
            return false
        else
            PLUGIN.invites[STEAM_0] = client:SteamID() -- parent
            PLUGIN:SaveData()
        end
	end
})

ix.command.Add("inviteRemove", {
	description = "Забирает право игрока присоединяться к серверу, пока его снова не пригласят",
	superAdminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, STEAM_0)
		if (PLUGIN.invites[STEAM_0] == nil) then
            client:notify("Игрок уже не имеет доступа к серверу")
            return false
        else
            PLUGIN.invites[STEAM_0] = nil -- parent
            PLUGIN:SaveData()
        end
	end
})

if (SERVER) then
    util.AddNetworkString("ixinviteList")
else
    net.Receive("ixinviteList", function()
        local invites = net.ReadTable();
        PrintTable(invites)
    end)
end
ix.command.Add("inviteList", {
	description = "Показывает список приглашенных людей и кто их пригласил",
	superAdminOnly = true,
	OnRun = function(self, client)
		net.Start("ixinviteList")
        net.WriteTable(PLUGIN.invites)
        net.Send(client)
        client:ChatNotify("Список отправлен вам в консоль")
	end
})

-- ix.command.Add("invite", {
-- 	description = "Дает право игроку по STEAM_0: STEAM_ID присоединяться к серверу",
-- 	superAdminOnly = false,
-- 	arguments = {
-- 		ix.type.string
-- 	},
-- 	OnRun = function(self, client, STEAM_0)
-- 		if (PLUGIN.invites[STEAM_0] != nil) then
--             client:notify("Игрок уже имеет доступ к серверу")
--             return false
--         else
--             PLUGIN.invites[STEAM_0] = client:SteamID() -- parent
--         end
-- 	end
-- }