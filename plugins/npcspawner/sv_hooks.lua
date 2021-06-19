
local PLUGIN = PLUGIN

PLUGIN.spawner = PLUGIN.spawner or {}
PLUGIN.items = PLUGIN.items or {}
PLUGIN.spawner.positions = PLUGIN.spawner.positions or {}

-- PLUGIN.items.common = {
-- 	"guitar"
-- }

-- PLUGIN.items.rare = {
-- 	"junkfood"
-- }

util.AddNetworkString("ixNPCSpawnerManager")
util.AddNetworkString("ixNPCSpawnerDelete")
util.AddNetworkString("ixNPCSpawnerEdit")
util.AddNetworkString("ixNPCSpawnerGoto")
util.AddNetworkString("ixNPCSpawnerSpawn")
util.AddNetworkString("ixNPCSpawnerChanges")

function PLUGIN:LoadData()
	PLUGIN.spawner.positions = self:GetData() or {}
end

function PLUGIN:SaveData()
	self:SetData(PLUGIN.spawner.positions)
end

function PLUGIN:AddNPCSpawner(client, position, title, npc)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end

	local respawnTime = ix.config.Get("NPCspawnerRespawnTime", 600)
	local offsetTime  = ix.config.Get("NPCspawnerOffsetTime", 100)
	print("Position: ",position)
	table.insert(PLUGIN.spawner.positions, {
		["ID"] = os.time(),
		["title"] = title,
		["delay"] = math.random(respawnTime, respawnTime + offsetTime),
		["lastSpawned"] = os.time(),
		["author"] = client:SteamID64(),
		["position"] = position,
		["npc"] = npc,
		["npcKilled"] = true
	})

end

function PLUGIN:RemoveNPCSpawner(client, title)
	if !(CAMI.PlayerHasAccess(client, "Helix - NPC Spawner", nil)) then return end

	for k, v in ipairs(PLUGIN.spawner.positions) do
		if (v.title:lower() == title:lower()) then
			table.remove(PLUGIN.spawner.positions, k)
			return true
		end
	end
	return false
end

function PLUGIN:ForceSpawn(client, spawner)
	if !(CAMI.PlayerHasAccess(client, "Helix - NPC Spawner", nil)) then return end
	if !(ix.config.Get("NPCspawnerActive")) then return end

	spawner.lastSpawned = os.time()
	--ix.item.Spawn(spawner.items[math.random(1, #spawner.items)], spawner.position)
	-- spawn a npc


	-- local rareChance = math.random(100)
	-- if (rareChance > tonumber(spawner.rarity)) then
	-- 	ix.item.Spawn(table.Random(PLUGIN.items.common), spawner.position)
	-- else
	-- 	ix.item.Spawn(table.Random(PLUGIN.items.rare), spawner.position)
	-- end
end

function PLUGIN:InitializedPlugins()
	self.Delay = CurTime() + ix.config.Get("NPCspawnerDelayCheck", 15)
end

function PLUGIN:Think() -- :\ replace with global timer wich ticks every ~30 seconds
	if (CurTime() < self.Delay) then return end
	self.Delay = CurTime() + ix.config.Get("NPCspawnerDelayCheck", 15)
	if (table.IsEmpty(PLUGIN.spawner.positions) or !(ix.config.Get("NPCspawnerActive", false))) then return end
	
	for k, v in pairs(PLUGIN.spawner.positions) do
		if (v.npcKilled) then
			if (v.lastSpawned + (v.delay) < os.time()) then
				v.lastSpawned = os.time()
				print(v.npc)
				local ent = ents.Create(v.npc)
				print(v.position)
				ent:Spawn()
				ent:SetPos(v.position)
				ent:SetVar("spawner", v)

				v.npcKilled = false
			end
		end
	end
end

function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
	if (npc:GetVar("spawner")) then
		npc:GetVar("spawner").npcKilled = true
	end
end

net.Receive("ixNPCSpawnerDelete", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - NPC Spawner", nil)) then return end

	local item = net.ReadString()
	PLUGIN:RemoveNPCSpawner(client, item)
end)

net.Receive("ixNPCSpawnerGoto", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - NPC Spawner", nil)) then return end

	local position = net.ReadVector()
	client:SetPos(position)
end)

net.Receive("ixNPCSpawnerSpawn", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - NPC Spawner", nil)) then return end

	local item = net.ReadTable()
	PLUGIN:ForceSpawn(client, item)
end)

net.Receive("ixNPCSpawnerChanges", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - NPC Spawner", nil)) then return end

	local changes = net.ReadTable()

	for k, v in ipairs(PLUGIN.spawner.positions) do
		if (v.ID == changes[1]) then
			v.title = changes[2]
			v.delay = math.Clamp(changes[3], 1, 10000)
			v.rarity  = math.Clamp(changes[4], 0, 100)
		end
	end
end)
