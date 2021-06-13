ITEM.name = "Темно-зеленая куртка"
ITEM.description = "Камуфляжная куртка с капюшоном, неплохо маскирующая в лесу"
ITEM.category = "Outfit"
ITEM.model = "models/black1dez/olr/dez_svoboda_light_suit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "model"
ITEM.targetReplacement = "military"
ITEM.durability = 100

ITEM.replacements = {
    { "bandit",     ITEM.targetReplacement },
    { "cs",         ITEM.targetReplacement },
    { "duty",       ITEM.targetReplacement },
    { "ecolog",     ITEM.targetReplacement },
    { "freedom",    ITEM.targetReplacement },
    { "killer",     ITEM.targetReplacement },
    { "lone",       ITEM.targetReplacement },
    { "military",   ITEM.targetReplacement },
    { "monolith",   ITEM.targetReplacement }
}

ITEM.bodyGroups = {
    ["torso"] = 0
}

-- ITEM.replacements = {
-- 	{"lone", ITEM.targetReplacement }, "killer"},
--     {"military", ITEM.targetReplacement }, "killer"}
-- --	{"group01", ITEM.targetReplacement }, "group02"}
-- }

-- bandit
-- cs
-- duty
-- ecolog
-- freedom
-- killer
-- lone
-- military
-- monolith
