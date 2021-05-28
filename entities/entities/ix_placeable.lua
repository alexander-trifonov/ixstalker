AddCSLuaFile()

--ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Placeable"
ENT.Category = "Placeable"
ENT.Spawnable = false

function ENT:Initialize()
end

function ENT:UpdatePhysics()
    -- Physics stuff
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )

    -- Init physics only on server, so it doesn't mess up physgun beam
    if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end

    -- Make prop to fall on spawn
    local phys = self:GetPhysicsObject()
    if ( IsValid( phys ) ) then phys:Wake() end
end

function ENT:SetData(data)
    if (data.Pos) then
        self:SetPos(data.Pos)
    end
    if (data.Angles) then
        self:SetAngles(data.Angles) 
    end
    if (data.Model) then
        self:SetModel(data.Model)
        self:UpdatePhysics()
    end
end