
local PLUGIN = PLUGIN

loot = loot or {}
loot.food = {
	"junkfood"
}
loot.misc = {
	"guitar"
}
loot.lowTierFood = {
	"junkfood",
	"soda"
}

ix.command.Add("ItemSpawnerAdd", {
	description = "@cmdItemSpawnerAdd",
	privilege = "Item Spawner",
	superAdminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.string
	},
	OnRun = function(self, client, title, category)
		if (loot[category] == nil) then
			local result = "Available categories: "
			for k,v in pairs(loot) do
				result = result..k.." "
			end
			return result
		end
		local location = client:GetEyeTrace().HitPos
		location.z = location.z + 10
		
		local items = loot[category]
		PLUGIN:AddSpawner(client, location, title, category, items)
	end
})

ix.command.Add("ItemSpawnerRemove", {
	description = "@cmdItemSpawnerRemove",
	privilege = "Item Spawner",
	superAdminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, title)
		return PLUGIN:RemoveSpawner(client, title) and "@cmdRemoved" or "@cmdNoRemoved"
	end
})

ix.command.Add("ItemSpawnerList", {
	description = "@cmdItemSpawnerList",
	privilege = "Item Spawner",
	superAdminOnly = true,
	OnRun = function(self, client)
		if (#PLUGIN.spawner.positions == 0) then
			return "@cmdNoSpawnPoints"
		end
		net.Start("ixItemSpawnerManager")
			net.WriteTable(PLUGIN.spawner.positions)
		net.Send(client)
	end
})
