ITEM.name = "Lootbox Base"
ITEM.model = "models/black1dez/olr/dez_box_metall_01.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Container with somethin inside"
ITEM.category = "Container"

ITEM.openingSounds = {
    "loot/woodcrack1.mp3",
    "loot/woodcrack2.mp3",
    "loot/woodcrack3.mp3"
}
ITEM.searchTime = 4
ITEM.items = {};

-- ITEM.functions.Open = {
--     name = "Открыть",
--     OnRun = function(item)
--         local client = item.player
--         -- if (item:GetData("receiver") != nil) then
--         --     client:Notify("Кто-то уже открывает")
--         --     return false
--         -- end

--         -- item:SetData("receiver", client)
--         client:RequestString("asdad", "asddd")
--         --client:SetAction("asdasd...", 4)
--         -- client:DoStaredAction(item:GetEntity(), 
--         --     function()
--         --         client:Notify("You have opened the box")
--         --         local uid = item.items[math.random(1, #item.items)]
--         --         ix.item.Spawn(uid, item:GetEntity():GetPos())
--         --         item:SetData("receiver", nil)
--         --         return true;
--         --     end,
--         --     item.searchTime,
--         --     function()
--         --         client:Notify("Look at the box!")
--         --         client:SetAction()
--         --         item:SetData("receiver", nil)
--         --         return false
--         --     end)
--         --return false
--     end,
--     OnCanRun = function(item)
--         return true
--     end
-- }

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