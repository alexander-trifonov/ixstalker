AddCSLuaFile()

ENT.Base = "ix_flora_base"
ENT.PrintName = "Fungus"
ENT.Spawnable = true
ENT.Model = "models/_monsters/xen/xen_fungus.mdl"
ENT.Name =  "Amsonia Polychroma"
ENT.Description = "Amsonia Polychroma or simple 'a fungus'"
ENT.LoopingSoundEnable = false
ENT.item = "Polyp Core"


function ENT:SetupDataTables()
	--self:NetworkVar("String", 0, "ItemID")
end
--npc/xen_polyp/explode_01.wav
function ENT:PreInit()
    if (SERVER) then
        --self.ScaleSize = math.Rand(0.5, 1.5)
        self.looted = false
        self:SetUseType(SIMPLE_USE)
    end
end

function ENT:PostInit()
    local bounds = 10
    self:SetSolid(SOLID_BBOX)
    local b1 = self:GetPos() + Vector(-bounds,-bounds,0)
    local b2 = self:GetPos() + Vector(bounds,bounds,0)
    self:SetCollisionBounds(Vector(-bounds,-bounds,0),Vector(bounds,bounds,bounds))
end

function ENT:OnRemovePost()
end

function ENT:DamagePlayersInRadius(radius)
    local entities = ents.FindInSphere(self:GetPos(), radius)
    local dmgInfo = DamageInfo()
    dmgInfo:SetDamageType(DMG_GENERIC)
    dmgInfo:SetDamage(10)
    for k,v in pairs(entities) do
        if (v:IsPlayer()) then
            v:TakeDamageInfo(dmgInfo)
            v:EmitSound("player/pl_pain"..math.random(5, 7)..".wav", 40)
        end
    end
end

function ENT:InflictVirus(player)
    if (SERVER) then
        --player:GetCharacter():SetData("fungus_infection", true)
        player:GetCharacter():InflictVirus("fungus_infection")
    end
end

-- Enabling player interaction menu
ENT.ShowPlayerInteraction = true
-- OnSelect is server-side code
function ENT:OnSelectHarvest(entity, client, data)
    if (!self.looted) then
        self:EmitSound("physics/flesh/flesh_squishy_impact_hard2.wav")
        if (SERVER) then
            if (self:GiveLoot(self.item, entity)) then
                local effectdata = EffectData()
                effectdata:SetOrigin(self:GetPos())
                effectdata:SetFlags(4)
                effectdata:SetScale(5)
                effectdata:SetDamageType(DMG_ACID)
                --effectdata:SetColor(10)
                --effectdata:SetScale(0.5)
                util.Effect("bloodspray", effectdata)
                self:DamagePlayersInRadius(200)
                self:InflictVirus(entity)
                self.looted = true
                self:StopLoopSounds()
                self:Remove()
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

