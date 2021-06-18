local PLUGIN = PLUGIN
PLUGIN.name = "Invites"
PLUGIN.author = "Mobious"
PLUGIN.description = "Whitelists server, allowing people to invite other"


ix.command.Add("sit", {
	description = "выберите место куда сесть",
	OnRun = function(self, client)
        local data = {}
        data.Model = client:GetModel()
        data.IsAnimation = true
        if (!client:IsFemale()) then
            data.animations = {
                "sit_ground",
                "sit_chair",
                "silo_sit",
                "sitccouchtv1",
                "sitchair1",
                "sitchairtable1",
                "sitcouchfeet1",
                --"sitcouchknees",
                --"drinker_sit",
                "plazaidle4",
                "roofidle2"
            }
        else
            -- Women :|
            data.animations = {
                "sit_chair",
                "sit_ground",
                "plazaidle4",
                "d1_t02_plaza_sit01_idle",
                --"d1_t03_sit_bed_entry",
                "d1_t03_sit_couch",
                "injured1",
                "injured2",
                "laycouch1",
                "silo_sit",
                "sitccouchtv1",
                "sitchair1",
                "sitchairtable1",
                "sitcouchfeet1"
                --"sitcouchknees",
                --"drinker_sit",
            }
        end
        ix.placement.PlaceEntity(client, data)
        -- net.Start("ixCommandSit")
        -- net.Send(client)
	end
})

if (SERVER) then
    util.AddNetworkString("ixCommandSit")
end

if (CLIENT) then
    local function RenderOptions()
        local data = data or {};
        data.Entity = data.Entity or "ix_placeable"
        client:GetCharacter():SetData("ixPlacementData", data);
        client:Give("ix_placement");
        client:SelectWeapon("ix_placement")
    end

    net.Receive("ixCommandSit", function()

    end)
    
end