
ITEM.name = "Edible Base"
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Something edible"
ITEM.category = "Consumables"
ITEM.bDropOnDeath = true
--ITEM.useSound = "items/ammo_pickup.wav"

-- function ITEM:GetDescription()
-- 	local rounds = self:GetData("rounds", self.ammoAmount)
-- 	return Format(self.description, rounds)
-- end

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
-- ITEM.functions.use = {
-- 	name = "Load",
-- 	tip = "useTip",
-- 	icon = "icon16/add.png",
-- 	OnRun = function(item)
-- 		local rounds = item:GetData("rounds", item.ammoAmount)

-- 		item.player:GiveAmmo(rounds, item.ammo)
-- 		item.player:EmitSound(item.useSound, 110)

-- 		return true
-- 	end,
-- }