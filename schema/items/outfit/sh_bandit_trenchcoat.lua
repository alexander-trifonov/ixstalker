ITEM.name = "Черный плащ"
ITEM.description = "Просто черный плащ с зеленой водолазкой, представляющий защиту не шибко больше, чем без него. Но пацаны оценят"
ITEM.category = "Outfit"
ITEM.model = "models/black1dez/olr/dez_bandit_suit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "model"
ITEM.targetReplacement = "bandit"
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
    ["torso"] = 5
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
