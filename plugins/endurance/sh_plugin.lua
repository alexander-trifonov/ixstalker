PLUGIN.name = "Endurance attribute"
PLUGIN.author = "Mobious"
PLUGIN.description = "Determines maximum character health"

ix.config.Add("DefaultHealth", 100, "Количество очков здоровья персонажей по-умолчанию", function()
    for k, v in pairs(player.GetAll()) do
        v:SetMaxHealth(ix.config.Get("DefaultHealth") + ix.config.Get("EnduranceHealth") * v:GetAttribute("endurance", 0))
    end
end, {
data = {min = 0, max = 10, decimals = 0},
category = "Health"
})

ix.config.Add("EnduranceHealth", 10, "Количество здоровья добавляющиеся за каждое очко выносливости", function()
for k, v in pairs(player.GetAll()) do
    v:SetMaxHealth(ix.config.Get("DefaultHealth") + ix.config.Get("EnduranceHealth") * v:GetAttribute("endurance", 0))
end
end, {
data = {min = 0, max = 20, decimals = 0},
category = "Health"
})

-- Runs upon /charsetattrubute
function PLUGIN:CharacterAttributeUpdated(client, self, key, value)
    if (key == "endurance") then
        client:SetMaxHealth(ix.config.Get("DefaultHealth") + ix.config.Get("EnduranceHealth") * value)
    end
end