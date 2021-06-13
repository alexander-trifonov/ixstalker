ITEM.name = "Плащ"
ITEM.description = "Коричневый плащ с темно-зеленой водолазкой без особой защиты от пуль"
ITEM.category = "Outfit"
ITEM.model = "models/black1dez/olr/dez_stalker_suit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "model"
ITEM.targetReplacement = "lone"
--ITEM.popularBy = "Преймущественно одевают одиночки"
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