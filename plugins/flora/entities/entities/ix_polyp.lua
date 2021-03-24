AddCSLuaFile()

ENT.Base = "ix_flora_base"
ENT.PrintName = "Polyp"
ENT.Spawnable = true
ENT.Model = "models/_monsters/xen/xen_polyp.mdl"
ENT.Name =  "Polypolus Amongus"
ENT.Description = "Floppa polyp"
ENT.Sounds = {
    "npc/xen_polyp/idle01.wav",
    "npc/xen_polyp/idle02.wav",
    "npc/xen_polyp/idle03.wav",
    "npc/xen_polyp/idle04.wav"
}
ENT.LoopingSound = true
ENT.item = "Polyp Core"


function ENT:SetupDataTables()
	--self:NetworkVar("String", 0, "ItemID")
end
--npc/xen_polyp/explode_01.wav
function ENT:PreInit()
    if (SERVER) then
        self.ScaleSize = math.Rand(0.5, 1.5)
        self.looted = false
        self:SetUseType(SIMPLE_USE)
    end
end

function ENT:PostInit() 
end

function ENT:OnRemovePost()
end

-- Enabling player interaction menu
ENT.ShowPlayerInteraction = true
-- OnSelect is server-side code
function ENT:OnSelectHarvest(entity, client, data)
    if (!self.looted) then
        self:EmitSound("doors/default_locked.wav")
        if (SERVER) then
            if (self:GiveLoot(self.item, entity)) then
                self:ChangeModel("models/_monsters/xen/xen_polyp_b.mdl")
                self.looted = true
                self:StopLoopSounds()
            end
        end
    else
        entity:Notify("Nothing to harvest!")
    end
end
-- Client-side code
function ENT:GetEntityMenu(client)
    local options = {}
    options["Examine"] = function()
        client:Notify("Uuu lala")
    end
    options["Harvest"] = function()
    end
    return options
end

