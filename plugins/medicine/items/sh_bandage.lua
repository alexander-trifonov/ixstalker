ITEM.name = "Бинт"
ITEM.model = Model("models/spec45as/stalker/items/bint.mdl")
ITEM.description = "Крепкий и качественный советский бинт, немного восстанавливает здоровье"
ITEM.category = "Medicine"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1
ITEM.threshold = 2 -- attribute threshold to use it
ITEM.healingPoints = 10 -- heal points per attribute point

if (CLIENT) then
    function ITEM:PopulateTooltip(tooltip)
        if (self.threshold) then
            local threshold = tooltip:AddRow("threshold")
            local text = "Необходимый навык медицины: "..self.threshold
            threshold:SetColor(Color(150, 60, 60))
            threshold:SetText(text or "")
            threshold:SizeToContents()
        end
    end
end

ITEM.functions.Use = {
    name = "Использовать на себе",
	OnRun = function(item, data)
        local client = item.player
        local points = hook.Run("healCalculate", client, item.threshold, nil) * item.healingPoints
        client:EmitSound("consumables/inv_bandage.ogg.mp3")
        client:SetAction("Вы используете бинт...", 3, function()
            client:SetHealth(math.Clamp(client:Health() + points, 1, client:GetMaxHealth()))
            if (points > 0) then
                client:Notify("Вы восстановили себе "..points.." очков здоровья")
            end
            item:Remove()
            return true
        end)
        return false
	end
}

ITEM.functions.UseOnOther = {
    name = "Использовать на другом",
	OnRun = function(item, data)
        local client = item.player
        local target = client:GetEyeTrace().Entity
        if (!target:IsPlayer()) then
            client:Notify("Вы должны смотреть на персонажа")
            return false
        else
            if (IsValid(target:GetCharacter())) then
                return false
            end
        end
        local points = hook.Run("healCalculate", client, item.threshold, target) * item.healingPoints
        client:EmitSound("consumables/inv_bandage.ogg.mp3")
        client:SetAction("Вы используете бинт...", 3, function()
            if (points > 0) then
                client:Notify("Вы восстановили "..points.." очков здоровья")
                target:Notify("Вам восстановили"..points.." очков здоровья")
            end
            target:SetHealth(math.Clamp(target:Health() + points, 1, target:GetMaxHealth()))
            item:Remove()
            return true
        end)
        return false        
	end
}