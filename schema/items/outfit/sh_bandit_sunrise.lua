ITEM.name = "Костюм 'Рассвет'"
ITEM.description = "Надежный костюм темного-коричневого цвета, позволяющий оставаться незамеченным в засаде в болотистой местности"
ITEM.category = "Outfit"
ITEM.model = "models/black1dez/olr/dez_stalker_suit.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "model"
ITEM.targetReplacement = "bandit"
--ITEM.popularBy = "Преймущественно используется бандитами"
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