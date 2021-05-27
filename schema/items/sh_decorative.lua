
ITEM.name = "Decorative"
ITEM.model = Model("models/props_borealis/bluebarrel001.mdl")
ITEM.description = "Декоративный проп для теста"
ITEM.category = "Furniture"
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
		--return true
	end
}
