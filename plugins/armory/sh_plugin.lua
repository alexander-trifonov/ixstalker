PLUGIN.name = "Armory attribute"
PLUGIN.author = "Mobious"
PLUGIN.description = "Allows to effectively repair, use and modify the armor"


function PLUGIN:ArmorRepairCalculate(client)
    if (client:GetCharacter():GetAttribute("weaponry") <= 2) then
        client:ChatNotify("Из-за низкого навыка портного дела вы только ухудшили состояние костюма...")
        client:EmitSound("physics/plastic/plastic_box_break"..math.random(1,2)..".wav")
        return -10;
    end
    return client:GetCharacter():GetAttribute("armory") * ix.config.Get("ArmoryRepair")
end

function PLUGIN:EntityTakeDamage(entity, dmgInfo)
	local inflictor = dmgInfo:GetInflictor()
    if (entity:IsPlayer()) then
        local client = entity
        local char = client:GetCharacter()
        local items = char:GetInventory():GetItems()
        local armor = char:GetInventory():HasItemOfBase("base_outfit", {
            ["equip"] = true,
            ["outfitCategory"] = "model" -- main armor
        })
        if (armor) then
            print("asdasd")
            armor:SetData("durability", armor:GetData("durability") - dmgInfo:GetDamage()/10)
            if (armor:GetData("durability") <= 0) then
                -- remove armor
            end
        end
	end
end

ix.config.Add("ArmoryRepair", 2, "Количество восстанавливаемой прочности у брони за 1 единицу в аттрибуте armory", nil, {
data = {min = 0, max = 10, decimals = 0},
category = "Armory"
})




-- local client = item.player
-- local char = client:GetCharacter()
-- local items = char:GetInventory():GetItems()

-- for _, v in pairs(items) do
--     if (v.id != item.id) then
--         local itemTable = ix.item.instances[v.id]

--         if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
--             client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
--             return false
--         end
--     end
-- end