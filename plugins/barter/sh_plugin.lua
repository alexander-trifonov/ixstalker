PLUGIN.name = "Barter attribute"
PLUGIN.author = "Mobious"
PLUGIN.description = "Allows to decrease/increase vendor's prices depending on character's attribute"

ix.config.Add("BarterMaxSellingProffit", 30, "Максимальная прибавка от стоимости предмета в процентах при продаже НПС при максимальном аттрибуте", nil, {
data = {min = 0, max = 100, decimals = 0},
category = "Trading"
})

ix.config.Add("BarterMaxBuyingSale", 30, "Максимальная скидка от стоимости предмета в процентах при покупки у НПС при максимальном аттрибуте", nil, {
data = {min = 0, max = 100, decimals = 0},
category = "Trading"
})

function PLUGIN:itemGetPrice(uniqueID, selling, client, price)
    price = price or ix.item.list[uniqueID].price
    if (CLIENT) then
        client = LocalPlayer()
    end
    local barter = client:GetCharacter():GetAttribute("barter")
    if (selling) then
        price = price * (1 + (ix.config.Get("BarterMaxSellingProffit")/100 * (barter / ix.attributes.list["barter"].maxValue)))
    else
        price = price * (1 - (ix.config.Get("BarterMaxBuyingSale")/100 * (barter / ix.attributes.list["barter"].maxValue)))
    end
    return math.floor(price)
end


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