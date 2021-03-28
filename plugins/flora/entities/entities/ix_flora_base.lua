
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Flora Base"
ENT.Category = "Helix Flora"
ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.bNoPersist = false
ENT.ShowPlayerInteraction = true
ENT.ScaleSize = 1.0

function ENT:SetupDataTables()
	--self:NetworkVar("String", 0, "ItemID")
end

function ENT:PreInt()
end

function ENT:PostInt()
end

-- SERVER
function ENT:Initialize()
	-- Custom for specific species
	self:PreInit()
	
	if (SERVER) then
		-- Common for all flora code
		self.health = 50
		self:SetModel(self.Model)
		self:SetModelScale(self.ScaleSize, 0.01)
		--self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetPersistent(true)
		
		local physObj = self:GetPhysicsObject()
		
		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Wake()
		end
		self:LoopSounds()
		self:Activate()
	end

	-- Custom for specific species
	self:PostInit()
end

if (SERVER) then
	function ENT:ChangeModel(model)
		self.Model = model
		self:SetModel(model)
		self:SetModelScale(self.ScaleSize, 0.1)
		self:PhysicsInit(SOLID_VPHYSICS)
		--self:Activate()
		
		self:SetPersistent(true)

		local physObj = self:GetPhysicsObject()
		
		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Wake()
		end
	end

	function ENT:LoopSounds()
		if (self.LoopingSoundEnable and IsValid(self)) then
			timer.Create(self:GetCreationID().."LoopingSound", 0,  0, function()
				local sound = self.Sounds[math.random(#self.Sounds)]
				self:EmitSound(sound, (self.LoopingSoundLevel or 75), (self.LoopingPitch or 100), (self.LoopingVolume or 1))
				timer.Adjust(self:GetCreationID().."LoopingSound", SoundDuration(sound) + math.random(3) + (self.LoopingSoundDelay or 0), nil, nil)
			end)
		end
	end

	function ENT:StopLoopSounds()
		if (timer.Exists(self:GetCreationID().."LoopingSound")) then
			timer.Remove(self:GetCreationID().."LoopingSound")
		end
	end

	function ENT:GiveLoot(item, player)
		local  uniqueID = item:lower()
		if (!ix.item.list[uniqueID]) then
			for k, v in SortedPairs(ix.item.list) do
				if (ix.util.StringMatches(v.name, uniqueID)) then
					uniqueID = k

					break
				end
			end
		end
		local bSuccess, error = player:GetCharacter():GetInventory():Add(uniqueID, 1)
		if (bSuccess) then
			player:Notify("You've found "..item.."!")
			return true
		else
			player:Notify("No space in the inventory!")
			return false
		end
	end

	function ENT:OnRemovePost()
	end

	function ENT:OnRemove()
		self:StopLoopSounds()
		self:OnRemovePost()
	end
	

	-- function ENT:GetEntityMenu(client)
	-- 	local options = {}
	-- 	options["Examine"] = function()
	-- 		print("Examining...")
	-- 	end
	-- 	return options
	-- end
	
else
	-- CLIENT
	ENT.PopulateEntityInfo = true
	function ENT:OnPopulateEntityInfo(flora)
		local text = flora:AddRow("name")
		text:SetImportant()
		text:SetText(self.Name)
		text:SizeToContents()
		
		local description = flora:AddRow("description")
		description:SetText(self.Description)
		description:SizeToContents()
	end
end

function ENT:OnOptionSelected(client, option, data)
end