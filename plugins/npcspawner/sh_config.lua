
local PLUGIN = PLUGIN

-- Item Spawner Toggle [On/Off]
ix.config.Add("NPCspawnerActive", true, "Toggle the NPC spawner.", nil, {
	category = "NPCSpawner"
})

-- Item Minimum Respawn
ix.config.Add("NPCspawnerOffsetTime", 60, "The range of NPC spawns around the timer.", nil, {
	category = "NPCSpawner",
	data = { min = 0, max = 999 }
})

-- Item Minimum Respawn
ix.config.Add("NPCspawnerRespawnTime", 600, "Time for an NPC to spawn at any position.", nil, {
	category = "NPCSpawner",
	data = { min = 1, max = 999 }
})

ix.config.Add("NPCspawnerDelayCheck", 15, "Delay in seconds for timer to check spanwers", nil, {
	category = "NPCSpawner",
	data = { min = 1, max = 600 }
})

-- ix.config.Add("containerOpenTime", 0.7, "How long it takes to open a container.", nil, {
-- 	data = {min = 0, max = 50},
-- 	category = "Containers"
-- })