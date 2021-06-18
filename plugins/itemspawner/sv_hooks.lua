
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

util.AddNetworkString("ixItemSpawnerManager")
util.AddNetworkString("ixItemSpawnerDelete")
util.AddNetworkString("ixItemSpawnerEdit")
util.AddNetworkString("ixItemSpawnerGoto")
util.AddNetworkString("ixItemSpawnerSpawn")
util.AddNetworkString("ixItemSpawnerChanges")

function PLUGIN:LoadData()
	PLUGIN.spawner.positions = self:GetData() or {}
end

function PLUGIN:SaveData()
	self:SetData(PLUGIN.spawner.positions)
end

function PLUGIN:AddSpawner(client, position, title, category, items)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end

	local respawnTime = ix.config.Get("spawnerRespawnTime", 600)
	local offsetTime  = ix.config.Get("spawnerOffsetTime", 100)

	local itemslist = items or loot[category]

	table.insert(PLUGIN.spawner.positions, {
		["ID"] = os.time(),
		["title"] = title,
		["delay"] = math.random(respawnTime, respawnTime + offsetTime),
		["lastSpawned"] = os.time(),
		["author"] = client:SteamID64(),
		["position"] = position,
		["rarity"] = ix.config.Get("spawnerRareItemChance", 0),
		["category"] = category,
		["items"] = itemslist,
		["itemTaken"] = true
	})

end

function PLUGIN:RemoveSpawner(client, title)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end

	for k, v in ipairs(PLUGIN.spawner.positions) do
		if (v.title:lower() == title:lower()) then
			table.remove(PLUGIN.spawner.positions, k)
			return true
		end
	end
	return false
end

function PLUGIN:ForceSpawn(client, spawner)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end
	if !(ix.config.Get("spawnerActive")) then return end

	spawner.lastSpawned = os.time()
	ix.item.Spawn(spawner.items[math.random(1, #spawner.items)], spawner.position)
	-- local rareChance = math.random(100)
	-- if (rareChance > tonumber(spawner.rarity)) then
	-- 	ix.item.Spawn(table.Random(PLUGIN.items.common), spawner.position)
	-- else
	-- 	ix.item.Spawn(table.Random(PLUGIN.items.rare), spawner.position)
	-- end
end

function PLUGIN:InitializedPlugins()
	self.Delay = CurTime() + ix.config.Get("spawnerDelayCheck", 15)
end

function PLUGIN:Think() -- :\ replace with global timer wich ticks every ~30 seconds
	if CurTime() < (self.Delay) then return end
	if (table.IsEmpty(PLUGIN.spawner.positions) or !(ix.config.Get("spawnerActive", false))) then return end
	
	for k, v in pairs(PLUGIN.spawner.positions) do

		if (v.itemTaken) then
			if (v.lastSpawned + (v.delay) < os.time()) then
				v.lastSpawned = os.time()
				local ent = ix.item.Spawn(v.items[math.random(1, #v.items)], v.position)
				local id =  ent.item.id
				
				-- 	ix.item.instances[id].hooks = {} -- IF THE FUCKING KEY IS NOT EXIST, IT WILL SEARCH IN IT'S PARENT METATABLE AKA ix.item.list
				-- 	-- SO WE MAKE SURE THAT THE KEY EXIST
				ix.item.instances[id].oldhooks = table.Copy(ix.item.instances[id].hooks) 
				ix.item.instances[id].hooks = {}
				ix.item.instances[id].hooks["take"] = function(item_picked, data)
					v.itemTaken = true
					v.lastSpawned = os.time()
					ix.item.instances[id].hooks = table.Copy(ix.item.instances[id].oldhooks) 
					ix.item.instances[id].oldhooks = nil
				end

				v.itemTaken = false
			end
		end
	end
	self.Delay = CurTime() + ix.config.Get("spawnerDelayCheck", 15)
end

net.Receive("ixItemSpawnerDelete", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end

	local item = net.ReadString()
	PLUGIN:RemoveSpawner(client, item)
end)

net.Receive("ixItemSpawnerGoto", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end

	local position = net.ReadVector()
	client:SetPos(position)
end)

net.Receive("ixItemSpawnerSpawn", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end

	local item = net.ReadTable()
	PLUGIN:ForceSpawn(client, item)
end)

net.Receive("ixItemSpawnerChanges", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Item Spawner", nil)) then return end

	local changes = net.ReadTable()

	for k, v in ipairs(PLUGIN.spawner.positions) do
		if (v.ID == changes[1]) then
			v.title = changes[2]
			v.delay = math.Clamp(changes[3], 1, 10000)
			v.rarity  = math.Clamp(changes[4], 0, 100)
		end
	end
end)
