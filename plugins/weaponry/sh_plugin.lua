PLUGIN.name = "Weaponry attribute"
PLUGIN.author = "Mobious"
PLUGIN.description = "Allows to effectively repair, use and modify the weapon"


function PLUGIN:itemRepairCalculate(client)
    if (client:GetCharacter():GetAttribute("weaponry") <= 2) then
        client:ChatNotify("Из-за низкого навыка оружейного дела вы поломали оружие")
        client:EmitSound("physics/metal/metal_computer_impact_soft"..math.random(1,3)..".wav")
        return -10;
    end
    return client:GetCharacter():GetAttribute("weaponry") * ix.config.Get("WeaponryRepair")
end

ix.config.Add("WeaponryRepair", 2, "Количество восстанавливаемой прочности у оружия за 1 единицу в аттрибуте weaponry", nil, {
data = {min = 0, max = 10, decimals = 0},
category = "Weaponry"
})

-- ix.config.Add("BarterMaxBuyingSale", 30, "Максимальная скидка от стоимости предмета в процентах при покупки у НПС при максимальном аттрибуте", nil, {
-- data = {min = 0, max = 100, decimals = 0},
-- category = "Trading"
-- })

-- function PLUGIN:itemGetPrice(uniqueID, selling, client, price)
--     price = price or ix.item.list[uniqueID].price
--     if (CLIENT) then
--         client = LocalPlayer()
--     end
--     local barter = client:GetCharacter():GetAttribute("barter")
--     if (selling) then
--         price = price * (1 + (ix.config.Get("BarterMaxSellingProffit")/100 * (barter / ix.attributes.list["barter"].maxValue)))
--     else
--         price = price * (1 - (ix.config.Get("BarterMaxBuyingSale")/100 * (barter / ix.attributes.list["barter"].maxValue)))
--     end
--     return math.floor(price)
-- end


-- Add this to ix.vendor.lua:
-- function ENT:GetPrice(uniqueID, selling)
--      ...
--
-- 		if (CLIENT) then
-- 			price = hook.Run("itemGetPrice", uniqueID, selling) or price
-- 		end
--
--      ...
-- end