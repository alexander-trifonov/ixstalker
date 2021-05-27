
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
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""

SWEP.UseHands = true

SWEP.FireWhenLowered = true
SWEP.HoldType = "fist"




function SWEP:Initialize()
	--util.PrecacheModel("models/props_borealis/bluebarrel001.mdl")
	self:SetHoldType(self.HoldType)
	if (CLIENT) then
		self.Data = self:GetOwner():GetNetVar("ixPlacementData");
		--util.PrecacheModel(self.Data["Model"])
		self.Ent = ents.CreateClientProp(self.Data["Model"])
		self.Ent:SetMaterial("models/debug/debugwhite")
		self.Ent:SetColor(Color(255,255,255, 128))
		self.Ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self.MinOffset = self.Ent:GetModelBounds();
		self.Angles = Angle(0,0,0)
	end
end

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() then return end
	if (CLIENT) then
		self.Angles:Add(Angle(0,2,0))
	end
end

function SWEP:SecondaryAttack()
	if !IsFirstTimePredicted() then return end
	if (CLIENT) then
		self.Angles:Add(Angle(0,-2,0))
	end
end

local function SpawnProp(entity)
	if (CLIENT) then
		net.Start("ixPlacementSpawnProp")
		net.WriteString(entity:GetModel())
		net.WriteVector(entity:GetPos())
		net.WriteAngle(entity:GetAngles())
		net.SendToServer()
	end
end

if (SERVER) then
	util.AddNetworkString("ixPlacementSpawnProp")
	net.Receive("ixPlacementSpawnProp", function(length, client)
		local ent = ents.Create("prop_physics")
		ent:SetModel(net.ReadString())
		ent:SetPos(net.ReadVector())
		ent:SetAngles(net.ReadAngle())
		ent:Spawn()
		ent:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav")
		local effectdata = EffectData()
		effectdata:SetOrigin(ent:GetPos())
		effectdata:SetEntity(ent)
		util.Effect( "RagdollImpact", effectdata) -- a placeholder for better effects
		-- timer.Create("ixPlacementSpawnProp"..ent:GetCreationID(), 0.7, 4, function()
		-- 	if (IsValid(ent)) then
		-- 		ent:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav")
		-- 	end
		-- end)
		client:StripWeapon("ix_placement")
		--EmitSound(Sound("physics/cardboard/cardboard_box_impact_soft1.wav"), ent:GetPos(), 0)
	end)
end

function SWEP:Think()
	if not IsFirstTimePredicted() then return end
	if (!IsValid(self:GetOwner())) then
		return
	end

	if (CLIENT) then
		if (IsValid(self.Ent)) then
			if (input.IsKeyDown(KEY_E)) then
				SpawnProp(self.Ent)
				self.Ent:Remove()
			end
			local pos = self:GetOwner():GetEyeTrace().HitPos
			pos.z = pos.z - self.MinOffset.z
			self.Ent:SetPos(pos);
			self.Ent:SetAngles(self.Angles)
		end
	end
end

function SWEP:OnRemove()
	if (IsValid(self.Ent)) then
		self.Ent:Remove();
	end
end

function SWEP:Holster()
	if (!IsFirstTimePredicted() or CLIENT) then
		return
	end
	if (!IsValid(self:GetOwner())) then
		return
	end
	if (CLIENT) then
		if (IsValid(self.Ent)) then
			self.Ent:Remove();
		end
	end
	if (SERVER) then
		self:GetOwner():StripWeapon("ix_placement")
	end
end