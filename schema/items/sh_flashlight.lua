ITEM.name = "Фонарик"
ITEM.model = Model("models/spec45as/stalker/upgrades/silencer.mdl")
ITEM.description = "Фонарик в металлическом черном корпусе, способный выдержать хороший удар"
ITEM.category = "Survival"
ITEM.width = 1
ITEM.height = 1
ITEM.uniqueID = "flashlight"


ITEM.postHooks.drop = function(item, result)
    local client = item.player
    client:Flashlight(false)
end
    