
AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Placement"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Author = "Mobious"
SWEP.Instructions = [[]]
SWEP.Purpose = "Placing items on the ground"
SWEP.Drop = false

SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.ViewTranslation = 4
if CLIENT then
	SWEP.NextAllowedPlayRateChange = 0
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""

SWEP.UseHands = true

SWEP.FireWhenLowered = true
SWEP.HoldType = "fist"




function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if (CLIENT) then
		self.Model = self:GetOwner():GetNWString("ixPlacementModel");
		self.Ent = ents.CreateClientside("prop_physics")
		self.Ent:SetModel(self.Model)
	end
end

function SWEP:Deploy()
	-- if (!IsValid(self:GetOwner())) then
	-- 	return
	-- end
	-- self.Data = self:GetOwner():GetNWString("ixPlacementData");
	-- if (self.Data == nil) then
	-- 	return
	-- end
	-- if (CLIENT) then
	-- 	self.Model = self:GetOwner():GetNWString("ixPlacementModel");
	-- 	self.Ent = ents.CreateClientside("prop_physics")
	-- 	self.Ent:SetModel(self.Model)
	-- 	print(self.Ent)
	-- end
end

function SWEP:Think()
	if (!IsValid(self:GetOwner())) then
		return
	end
	if (CLIENT) then
		if (IsValid(self.Ent)) then
			self.Ent:SetPos(self:GetOwner():GetEyeTrace().HitPos);
		end
	end
end

-- function SWEP:OnRemove()
-- 	if (SERVER) then
-- 	end
-- end

function SWEP:Remove()
	if (IsValid(self.Ent)) then
		self.Ent:Remove();
	end
end

function SWEP:Holster()
	if (!IsValid(self:GetOwner())) then
		return
	end
	if (SERVER) then
		self:GetOwner():StripWeapon("ix_placement")
	end
end
-- function SWEP:Deploy()
-- 	if (!IsValid(self:GetOwner())) then
-- 		return
-- 	end

-- 	return true
-- end


-- 	return true
-- end


-- end



-- function SWEP:Reload()
-- 	if (!IsFirstTimePredicted()) then
-- 		return
-- 	end
-- end
