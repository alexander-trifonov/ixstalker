ITEM.name = "Mercenary Outfit 1"
ITEM.description = "A merc armor"
ITEM.category = "TEST"
ITEM.model = "models/black1dez/olr/dez_stalker_killer_suit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "model"
ITEM.targetReplacement = "killer"
ITEM.durability = 300

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
    ["torso"] = 2
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
