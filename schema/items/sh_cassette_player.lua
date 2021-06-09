
ITEM.name = "Cassette Player"
ITEM.model = Model("models/unconid/walkmann/walkmann.mdl")
ITEM.description = "A blue cassette player"
ITEM.category = "Electronics"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

ITEM.functions.Play = {
	OnRun = function(item)
        
		return false
	end
}
