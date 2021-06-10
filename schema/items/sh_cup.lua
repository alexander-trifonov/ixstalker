-- g_fist_r
ITEM.name = "Жестяная Кружка"
ITEM.model = Model("models/black1dez/olr/dez_kitchen_krujka.mdl")
ITEM.description = "Обязательный предмет в рюкзаке каждого сталкера"
ITEM.category = "Food Tools"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

if (CLIENT) then
    function ITEM:PopulateTooltip(tooltip)
        if (self:GetData("sign")) then
            local sign = tooltip:AddRow("sign")
            local text = "Подписано: "..self:GetData("sign")--.."\n"..self:GetDescription()
            sign:SetColor(Color(255, 150, 20))
            sign:SetText(text or "")
	        sign:SizeToContents()
        end
        local additional = tooltip:AddRow("additional")
        local text = "Позволяет пить не из рук"
        --additional:SetColor(Color(60, 150, 60))
        additional:SetText(text or "")
        additional:SizeToContents()
    end
end

ITEM.functions.Sign = {
    name = "Подписать",
	OnRun = function(item)
		local client = item.player
        client:RequestString(item.name, "Подписать кружку", function(text)
            if (text == "") then return false end
            item:SetData("sign", text)
        end, "")
        
        return false
	end,
    OnCanRun = function(item)
        return (item:GetData("sign") == nil)
    end
}
