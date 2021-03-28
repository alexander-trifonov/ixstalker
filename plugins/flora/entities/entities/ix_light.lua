AddCSLuaFile()

ENT.Base = "ix_flora_base"
ENT.PrintName = "Light"
ENT.Spawnable = true
ENT.Model = "models/_monsters/xen/xen_light.mdl"
ENT.Name =  "Pontederia Ciliaris"
ENT.Description = "Description"
ENT.Sounds = {
    "npc/antlion/idle1.wav",
    "npc/antlion/idle1.wav",
    "npc/antlion/idle3.wav",
    "npc/antlion/idle4.wav"
}
ENT.LoopingPitch = 20
ENT.LoopingSoundLevel = 50
ENT.LoopingVolume = 1
ENT.LoopingSoundEnable = true
ENT.LoopingSoundDelay = 5


function ENT:SetupDataTables()
	--self:NetworkVar("String", 0, "ItemID")
end

function ENT:PreInit()
end



function ENT:GoSleep()
    if (self.Awake) then
        self:SetSkin(1)
        self:EmitSound("npc/barnacle/barnacle_tongue_pull2.wav", 50)
        self:SetAutomaticFrameAdvance(true)
        self:ResetSequence("retract")
        timer.Create(self:GetCreationID().."GoSleep", self:SequenceDuration("retract"), 1, function()
            self.Think = self.oldThink
            self:ResetSequence("hide")
            self:SetAutomaticFrameAdvance(false)
            self.Awake = false
        end)
    end
end

function ENT:WakeUp()
    if (!self.Awake) then
        self.Awake = true
        self:EmitSound("npc/barnacle/barnacle_tongue_pull1.wav", 50, 225)
        self:SetSkin(0)
        self:SetAutomaticFrameAdvance(true)
        self:SetSequence("deploy")
        --self:SetPlaybackSpeed(0.5) -- doesn't work 
        self.oldThink = self.Think
        self.Think = function()  
            self:NextThink(CurTime());  
            return true;  
        end
        timer.Create(self:GetCreationID().."WakeUp", self:SequenceDuration("deploy"), 1, function()
            self:ResetSequence("idle")
        end)
    end
end

if (SERVER) then
    function ENT:OnRemovePost()
        if (timer.Exists(self:GetCreationID().."WakeUp")) then
            timer.Remove(self:GetCreationID().."WakeUp")
        end

        if (timer.Exists(self:GetCreationID().."GoSleep")) then
            timer.Remove(self:GetCreationID().."GoSleep")
        end
    end

    function ENT:StartTouch(activator)
        if (activator:IsPlayer()) then
            self:WakeUp()
        end
    end

    function ENT:EndTouch(activator)
        if (activator:IsPlayer()) then
            self:GoSleep()
        end
    end
end 

ENT.TriggerRadius = 60
function ENT:PostInit()
    if (SERVER) then
        --self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:SetSkin(1)
        self:ResetSequence("hide")
        self:SetSolid(SOLID_BBOX)
        self:SetTrigger(true)
        self:SetCollisionBounds(Vector(-5,-5,0),Vector(5,5,75))
        self:UseTriggerBounds(true, self.TriggerRadius)
        --self:SetPos(self:GetPos() + self:GetUp() * Vector(1,1,-10)) --not working on SOLID_BBOX
    end
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

