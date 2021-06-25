
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
	timer.Simple(0.5, function()
		
	end)
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
		if (client:GetPos():DistToSqr(data.Pos) > data.Range*data.Range) then
			client:Notify("Слишком далеко")
			if (client:HasWeapon("ix_placement")) then
				client:StripWeapon("ix_placement")
			end
			client:SetLocalVar("ixPlacementData")
			return false
		end
		if (data.ItemUniqueID) then
			if (!client:CanPlaceEntity(data.ItemUniqueID)) then return end
		end
		local ent = ents.Create(data.Entity)
		if (ent.SetData) then
			ent:SetData(data)
		else
			ent:SetPos(data.Pos)
			ent:SetAngles(data.Angles)
		end
		ent:Spawn()
		if (client:HasWeapon("ix_placement")) then
			client:StripWeapon("ix_placement")
		end
		client:GetCharacter():GetInventory():Remove(data.ItemID)
		client:SetLocalVar("ixPlacementData")
		ent:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav")
	end)
end

function SWEP:SpawnEntity()
	if (CLIENT) then
		self.Data.Pos = self.Ent:GetPos()
		self.Data.Angles = self.Ent:GetAngles()
		self.Data.Range = self.Range
		net.Start("ixPlacementSpawnEntity")
		net.WriteTable(self.Data)
		net.SendToServer()
		self.Ent:Remove()
	end
end

if (SERVER) then
	util.AddNetworkString("ixSetPlayerAnimation")
	net.Receive("ixSetPlayerAnimation", function(length, client)
		local data = net.ReadTable();
		if (client:GetPos():DistToSqr(data.Pos) > data.Range*data.Range) then
			client:Notify("Слишком далеко")
			if (client:HasWeapon("ix_placement")) then
				client:StripWeapon("ix_placement")
			end
			client:SetLocalVar("ixPlacementData")
			return false
		end
		
		client:SetPos(data.Pos)
		client:SetAngles(data.Angles)
		client.ixUntimedSequence = true -- allows to press +jump and leave sequence
		client:SetNetVar("actEnterAngle", client:GetAngles()) -- allows to press +jump and leave sequence
		client:ForceSequence(data.sequence, function()
			client.ixUntimedSequence = nil
			client:SetNetVar("actEnterAngle")

			net.Start("ixActLeave")
			net.Send(client)
			client:SetPos(data.OldPos)
		end, 0)
		net.Start("ixActEnter")
			net.WriteBool(true)
		net.Send(client)
		client:SetLocalVar("ixPlacementData")
		if (client:HasWeapon("ix_placement")) then
			client:StripWeapon("ix_placement")
		end
	end)
end

function SWEP:SetPlayerAnimation()
	self.Data.OldPos = self:GetOwner():GetPos()
	self.Data.Pos = self.Ent:GetPos()
	self.Data.Angles = self.Ent:GetAngles()
	self.Data.sequence = self.Data.animations[self.AnimationIndex]
	self.Data.Range = self.Range
	net.Start("ixSetPlayerAnimation")
	net.WriteTable(self.Data)
	net.SendToServer()
	self.Ent:Remove()
end

function SWEP:Think()
	if not IsFirstTimePredicted() then return end
	if (!IsValid(self:GetOwner())) then
		return
	end

	if (CLIENT) then
		if (self.Data == nil) then
			if (self:GetOwner():GetLocalVar("ixPlacementData") == nil) then return end
			local data = self:GetOwner():GetLocalVar("ixPlacementData")
			self:GetOwner():Notify("ЛКМ, ПКМ - поворачивать, R - переключать, E - поставить")
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
			if (self.Data.IsAnimation) then
				self.AnimationIndex = 1
				self.Ent:ResetSequence(self.Data.animations[self.AnimationIndex])
				self.AnimationPressDelay = CurTime()
			end
			self.Range = 100
		end

		if (IsValid(self.Ent)) then
			if (self.Data.IsAnimation) then
				if (CurTime() >= self.AnimationPressDelay) then
					if (input.IsKeyDown(KEY_R)) then
						self.AnimationIndex = self.AnimationIndex + 1
						if (self.AnimationIndex > #self.Data.animations) then
							self.AnimationIndex = 1
						end
						self.Ent:ResetSequence(self.Data.animations[self.AnimationIndex])
						self.AnimationPressDelay = CurTime() + 0.2
					end
					if (input.IsKeyDown(KEY_E)) then
						self:SetPlayerAnimation()
						self.AnimationPressDelay = CurTime() + 0.2
					end
				end
			else
				if (input.IsKeyDown(KEY_E)) then
					self:SpawnEntity()
				end
			end
			self.Ent:SetPos(self:GetOwner():GetEyeTrace().HitPos - Vector(0, 0, self.Ent:GetCollisionBounds().z));
			self.Ent:SetAngles(self.Angles)
			if (self.AnimationIndex) then
				self.Ent:SetPos(self.Ent:GetPos() + Vector(0, 0, -20))
			end
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