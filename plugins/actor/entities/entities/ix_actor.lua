
ENT.Type = "anim"
ENT.PrintName = "Actor"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.isVendor = false
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
	self:NetworkVar("String", 2, "Speech")
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/stalker_roleplay/lone/male_0"..math.random(1,9)..".mdl")
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)

		self:SetDisplayName("Иван Иванов")
		self:SetDescription("")
		self:SetSpeech("")

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end	

	-- timer.Simple(1, function()
	-- 	print("initializing vendor")
	-- 	if (IsValid(self)) then
	-- 		self:SetAnim()
	-- 	end
	-- end)
end

function ENT:SetAnim()

	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v != "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	if (self:GetSequenceCount() > 1) then
		self:ResetSequence(4)
	end
end

if (SERVER) then
	local PLUGIN = PLUGIN

	function ENT:SpawnFunction(client, trace)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		local entity = ents.Create("ix_actor")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(angles)
		entity:Spawn()

		PLUGIN:SaveData()

		return entity
	end

	function ENT:Use(activator)
		--local character = activator:GetCharacter()
		if (self:GetSpeech() != "") then
			activator:ChatNotify(self:GetDisplayName()..": "..self:GetSpeech())
		end
	end
else
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetDisplayName())
		name:SizeToContents()

		local descriptionText = self:GetDescription()

		if (descriptionText != "") then
			local description = container:AddRow("description")
			description:SetText(self:GetDescription())
			description:SizeToContents()
		end
	end
end

