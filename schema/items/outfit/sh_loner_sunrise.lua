ITEM.name = "Костюм 'Рассвет'"
ITEM.description = "Надежный костюм светлого оттенка, ясно показывающий нейтральность и хорошие намерения владельца"
ITEM.category = "Outfit"
ITEM.model = "models/black1dez/olr/dez_stalker_suit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "model"
ITEM.targetReplacement = "lone"
ITEM.popularBy = "Преймущественно надевают одиночки"
ITEM.durability = 200

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