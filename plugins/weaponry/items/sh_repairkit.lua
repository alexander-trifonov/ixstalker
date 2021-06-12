ITEM.name = "Ремонтный набор оружейника"
ITEM.model = Model("models/spec45as/stalker/quest/box_toolkit_2.mdl")
ITEM.description = "Позволяет чинить оружие"
ITEM.category = "Weaponry Tools"
ITEM.width = 2 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 2
ITEM.durability = 100
ITEM.durabilityDesc  = "Осталось запасов около: "

function ITEM:OnInstanced(index, x, y, item)
    print("instanced")
    self:SetData("durability", self:GetData("durability") or self.durability or 66)
end

if (CLIENT) then
    function ITEM:PopulateTooltip(tooltip)
        if (self.durability) then
            local durability = tooltip:AddRow("durability")
            local text = ((self.durabilityDesc) or ("Осталось прочности: "))..(self:GetData("durability") or self.durability)
            durability:SetColor(Color(60, 150, 60))
            durability:SetText(text or "")
            durability:SizeToContents()
        end
    end
end

ITEM.functions.combine = {
	OnRun = function(item, data)
        local client = item.player
        --ix.item.instances[data[1]] -- item
        local other_item = ix.item.instances[data[1]]
        local new_durability = math.Clamp(other_item:GetData("durability") + hook.Run("itemRepairCalculate", client) or 1, 0, 100) 
        other_item:SetData("durability", new_durability)
        item:SetData("durability", item:GetData("durability") - 10)
        client:EmitSound("physics/metal/weapon_impact_soft"..math.random(1,3)..".wav")
        if (item:GetData("durability") <= 0) then
            return true
        end
        return false
	end,
    OnCanRun = function(item, data)
        local other_item = ix.item.instances[data[1]]
        local durability = other_item:GetData("durability")
        return (durability != nil) and (durability <= 100)
    end
}