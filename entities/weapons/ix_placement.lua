
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

function SWEP:SetupDataTables()
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	if (CLIENT) then
		local data = self:GetOwner():GetCharacter():GetData("ixPlacementData")
		self.Data = data;
		--util.PrecacheModel(self.Data.Model);
		-- DO NOT DO ents.CreateClientProp("your/model") - IT CAUSES UNEXPECTED BEHAVIOR
		-- DO THIS:
		self.Ent = ents.CreateClientProp()
		self.Ent:SetModel(self.Data.Model)
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

if (SERVER) then
	util.AddNetworkString("ixPlacementSpawnEntity")
	net.Receive("ixPlacementSpawnEntity", function(length, client)
		local data = net.ReadTable();
		if (data.ItemUniqueID) then
			if (!client:CanPlaceEntity(data.ItemUniqueID)) then return end
		end
		local ent = ents.Create(data.Entity)
		if (ent.SetData) then
			ent:SetData(data)
		else
			PrintTable(data)
			ent:SetPos(data.Pos)
			ent:SetAngles(data.Angles)
		end
		ent:Spawn()
		if (client:HasWeapon("ix_placement")) then
			client:StripWeapon("ix_placement")
		end
		client:GetCharacter():GetInventory():Remove(data.ItemID)
		ent:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav")
	end)
end

function SWEP:SpawnEntity()
	if (CLIENT) then
		self.Data.Pos = self.Ent:GetPos()
		self.Data.Angles = self.Ent:GetAngles()
		net.Start("ixPlacementSpawnEntity")
		net.WriteTable(self.Data)
		net.SendToServer()
		self.Ent:Remove()
	end
end

function SWEP:Think()
	if not IsFirstTimePredicted() then return end
	if (!IsValid(self:GetOwner())) then
		return
	end

	if (CLIENT) then
		if (IsValid(self.Ent)) then
			if (input.IsKeyDown(KEY_E)) then
				self:SpawnEntity()
			end
			local pos = self:GetOwner():GetEyeTrace().HitPos
			pos.z = pos.z - self.MinOffset.z
			self.Ent:SetPos(self:GetOwner():GetEyeTrace().HitPos  + Vector(0, 0, self.Ent:GetCollisionBounds().z));
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