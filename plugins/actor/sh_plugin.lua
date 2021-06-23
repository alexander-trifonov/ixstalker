
-- luacheck: globals VENDOR_BUY VENDOR_SELL VENDOR_BOTH VENDOR_WELCOME VENDOR_LEAVE VENDOR_NOTRADE VENDOR_PRICE
-- luacheck: globals VENDOR_STOCK VENDOR_MODE VENDOR_MAXSTOCK VENDOR_SELLANDBUY VENDOR_SELLONLY VENDOR_BUYONLY VENDOR_TEXT

local PLUGIN = PLUGIN

PLUGIN.name = "Actor"
PLUGIN.author = "Chessnut & Mobious"
PLUGIN.description = "Add empty npc with animation, bodygroup and maybe speach"

CAMI.RegisterPrivilege({
	Name = "Helix - Manage Vendors",
	MinAccess = "admin"
})

ix.command.Add("ActorSetAnimation", {
	adminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, sequence)
		local entity = client:GetEyeTrace().Entity
		if (entity:GetClass() != "ix_actor") then
			return "Нужно смотреть на актера-нпс"
		end
		local seqNumber = entity:LookupSequence(sequence)
		if (seqNumber == -1) then
			return "Не существующая анимация для этой модели"
		end
		entity:ResetSequence(seqNumber)
	end
})

ix.command.Add("ActorSetName", {
	adminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, name)
		local entity = client:GetEyeTrace().Entity
		if (entity:GetClass() != "ix_actor") then
			return "Нужно смотреть на актера-нпс"
		end
		entity:SetDisplayName(name)
	end
})

ix.command.Add("ActorSetDescription", {
	adminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, desc)
		local entity = client:GetEyeTrace().Entity
		if (entity:GetClass() != "ix_actor") then
			return "Нужно смотреть на актера-нпс"
		end
		entity:SetDescription(desc)
	end
})

ix.command.Add("ActorSetSpeech", {
	adminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, text)
		local entity = client:GetEyeTrace().Entity
		if (entity:GetClass() != "ix_actor") then
			return "Нужно смотреть на актера-нпс"
		end
		entity:SetSpeech(text)
	end
})



if (SERVER) then

	function PLUGIN:SaveData()
		local data = {}

		for _, entity in ipairs(ents.FindByClass("ix_actor")) do
			local bodygroups = {}

			for _, v in ipairs(entity:GetBodyGroups() or {}) do
				bodygroups[v.id] = entity:GetBodygroup(v.id)
			end

			data[#data + 1] = {
				name = entity:GetDisplayName(),
				description = entity:GetDescription(),
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
				bodygroups = bodygroups,
				animation = entity:GetSequence()
			}
		end

		self:SetData(data)
	end

	function PLUGIN:LoadData()
		for _, v in ipairs(self:GetData() or {}) do
			local entity = ents.Create("ix_actor")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:Spawn()

			entity:SetModel(v.model)
			entity:SetSkin(v.skin or 0)
			entity:SetSolid(SOLID_BBOX)
			entity:PhysicsInit(SOLID_BBOX)

			local physObj = entity:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:EnableMotion(false)
				physObj:Sleep()
			end

			entity:SetDisplayName(v.name)
			entity:SetDescription(v.description)

			for id, bodygroup in pairs(v.bodygroups or {}) do
				entity:SetBodygroup(id, bodygroup)
			end

			entity:ResetSequence(v.animation)
		end
	end

end