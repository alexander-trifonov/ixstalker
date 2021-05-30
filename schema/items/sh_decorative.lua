
ITEM.name = "Decorative"
ITEM.model = Model("models/props_junk/cardboard_box001b.mdl")
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
		data.Entity = "ix_placeable"
        data.Model = "models/props_c17/FurnitureCouch002a.mdl"
		data.ItemID = item:GetID() -- ID of instance in the inventory
		data.ItemUniqueID = item.uniqueID -- general ID, a name, "decorative" in this case
		ix.placement.PlaceEntity(client, data)
		-- Returning true will cause the item to be removed from the character's inventory.
		return false
	end
}
