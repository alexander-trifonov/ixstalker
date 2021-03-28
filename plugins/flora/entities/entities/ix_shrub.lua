AddCSLuaFile()

ENT.Base = "ix_flora_base"
ENT.PrintName = "Shrub"
ENT.Spawnable = true
ENT.Model = "models/props_foliage_new/xen_shrub_b.mdl"
ENT.Name =  "Shrub"
ENT.Description = "Red grass"
ENT.LoopingSoundEnable = false

function ENT:SetupDataTables()
	--self:NetworkVar("String", 0, "ItemID")
end
--npc/xen_polyp/explode_01.wav
function ENT:PreInit()
    if (SERVER) then
        self.ScaleSize = math.Rand(0.5, 0.7)
        self:SetUseType(SIMPLE_USE)
    end
end

function ENT:PostInit()
    if (SERVER) then
        self:SetPos(self:GetPos() + Vector(1,1,-15))
        --self:SetModelScale(self.ScaleSize, 0)
		--self:Activate()
        --self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        --self:SetSolid(SOLID_VPHYSICS)
		--self:PhysicsInit(SOLID_VPHYSICS)
    end
end

function ENT:OnRemovePost()
end

-- Enabling player interaction menu
ENT.ShowPlayerInteraction = false
