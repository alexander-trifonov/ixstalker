
ITEM.name = "Campfire"
ITEM.model = Model("models/props_junk/cardboard_box004a.mdl")
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
		data.Entity = "ix_campfire"
        data.Model = "models/props_unique/firepit_campground.mdl"
		data.ItemID = item:GetID() -- ID of instance in the inventory
		data.ItemUniqueID = item.uniqueID -- general ID, a name, "decorative" in this case
		ix.placement.PlaceEntity(client, data)
		-- Returning true will cause the item to be removed from the character's inventory.
		return false
	end
}
