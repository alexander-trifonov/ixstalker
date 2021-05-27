
ITEM.name = "Campfire"
ITEM.model = Model("models/z-o-m-b-i-e/st/fireplace/st_fireplace_01_1.mdl")
ITEM.description = "Набор для разведения костра, у которого можно согреться, отдохнуть и поесть"
ITEM.category = "Survival"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

ITEM.noBusiness = true
-- You can define additional actions for this item as such:
ITEM.functions.Place = {
	OnRun = function(item)
		local client = item.player
        local data = {};
        data.Model = item.model
		ix.placement.PlaceEntity(client, data)
		-- Returning true will cause the item to be removed from the character's inventory.
		return true
	end
}
