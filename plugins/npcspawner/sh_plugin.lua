
local PLUGIN = PLUGIN

PLUGIN.name = "NPC Spawner System"
PLUGIN.author = "Gary Tate, modified by Mobious"
PLUGIN.description = "Allows staff to select NPC spawn points with great configuration."

CAMI.RegisterPrivilege({
	Name = "Helix - NPC Spawner",
	MinAccess = "admin"
})

ix.util.Include("sh_config.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
