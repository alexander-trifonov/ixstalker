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


-- Since I can't identify what item is actually gonna be sold and modify the price by it's durability, I'll disallow selling damaged items at all
function PLUGIN:CanPlayerTradeWithVendor(client, entity, uniqueID, isSellingToVendor)
    if (SERVER) then
        if (isSellingToVendor) then
            for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
                if (v.uniqueID == uniqueID and v:GetID() != 0 and ix.item.instances[v:GetID()] and v:GetData("equip", false) == false) then
                    if (v:GetData("durability")) then
                        if (v:GetData("durability") != 100) then
                            client:Notify("В вашем инвентаре есть такой предмет с не максимальной прочностью")
                            return false
                        end
                    end
                end
            end
        end
    end
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