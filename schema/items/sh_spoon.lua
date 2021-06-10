ITEM.name = "Ложка"
ITEM.model = Model("models/black1dez/olr/dez_kitchen_lojka.mdl")
ITEM.description = "Обязательный предмет в рюкзаке каждого сталкера"
ITEM.category = "Food Tools"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

if (CLIENT) then
    function ITEM:PopulateTooltip(tooltip)
        local additional = tooltip:AddRow("additional")
        local text = "Позволяет есть пищу не руками"
        --additional:SetColor(Color(60, 150, 60))
        additional:SetText(text or "")
        additional:SizeToContents()
    end
end