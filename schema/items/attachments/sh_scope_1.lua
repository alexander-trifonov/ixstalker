ITEM.name = "Scope 1"
ITEM.model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.description = "A simple dimple"
--ITEM.category = "Weapon Attachments"
ITEM.width = 1
ITEM.height = 1
ITEM.uniqueID = "mifl_fas2_optic_pso1"

--ITEM.attname = "mifl_fas2_optic_pso1"

function ITEM:OnInstanced(index, x, y, item)
    self:SetData("attname", self.attname)
end