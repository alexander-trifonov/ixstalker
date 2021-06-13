ATTRIBUTE.name = "Выносливость"
ATTRIBUTE.description = "Сильно увеличивает здоровье персонажа"
ATTRIBUTE.noStartBonus = false

ATTRIBUTE.maxValue = 10

-- Runs upon character loading
function ATTRIBUTE:OnSetup(client, value)
    client:SetMaxHealth(ix.config.Get("DefaultHealth") + ix.config.Get("EnduranceHealth") * value)
end