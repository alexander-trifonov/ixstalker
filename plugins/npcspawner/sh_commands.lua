
local PLUGIN = PLUGIN

local availableNPCS = {
	["npc_wick_mutant_dog"] = true,
	["npc_wick_mutant_snork"] = true,
	["npc_wick_mutant_bloodsucker_adult"] = true,
	["npc_wick_mutant_bloodsucker_young"] = true,
	["npc_wick_mutant_zombiecit_fast"] = true,
	["npc_wick_mutant_zombiecit_slow"] = true,
	["npc_headcrab"] = true
}

ix.command.Add("NPCSpawnerAdd", {
	description = "@cmdNPCSpawnerAdd",
	privilege = "NPC Spawner",
	superAdminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.string
	},
	OnRun = function(self, client, title, npc)
		if (availableNPCS[npc] == nil) then
			local result = "Available NPCS: "
			for k,v in pairs(availableNPCS) do
				result = result..k.." "
			end
			return result
		end
		local location = client:GetEyeTrace().HitPos
		--location.z = location.z + 10
		
		PLUGIN:AddNPCSpawner(client, location, title, npc)
	end
})

ix.command.Add("NPCSpawnerRemove", {
	description = "@cmdNPCSpawnerRemove",
	privilege = "NPC Spawner",
	superAdminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, title)
		return PLUGIN:RemoveNPCSpawner(client, title) and "@cmdNPCRemoved" or "@cmdNoNPCRemoved"
	end
})

ix.command.Add("NPCSpawnerList", {
	description = "@cmdNPCSpawnerList",
	privilege = "NPC Spawner",
	superAdminOnly = true,
	OnRun = function(self, client)
		if (#PLUGIN.spawner.positions == 0) then
			return "@cmdNoNPCSpawnPoints"
		end
		net.Start("ixNPCSpawnerManager")
			net.WriteTable(PLUGIN.spawner.positions)
		net.Send(client)
	end
})
