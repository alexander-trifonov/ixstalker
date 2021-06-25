ITEM.name = "Коробка"
ITEM.base = "base_lootbox"
ITEM.category = "Lootbox T1"
ITEM.model = Model("models/black1dez/olr/dez_box_wood_01.mdl")
ITEM.description = "Что-то может быть внутри"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

ITEM.noBusiness = true

ITEM.items = {
    "konservi",
    "water",
    "bread",
    "ammo_pistol"
}

ITEM.functions.take.OnCanRun = function(item)
    return false
end
