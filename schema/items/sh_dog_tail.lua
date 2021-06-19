ITEM.name = "Хвост"
ITEM.model = Model("models/spec45as/stalker/quest/item_dog_tail.mdl")
ITEM.description = "Трофей, подтверждающий, что владелец убил дикую собаку в Зоне"
ITEM.category = "Animal Loot"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

if (CLIENT) then
    function ITEM:PopulateTooltip(tooltip)
        local additional = tooltip:AddRow("additional")
        local text = "Отвратительно пахнет"
        additional:SetColor(Color(200, 10, 10))
        additional:SetText(text or "")
        additional:SizeToContents()
    end
end