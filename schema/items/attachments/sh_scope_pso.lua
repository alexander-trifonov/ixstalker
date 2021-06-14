ITEM.name = "PSO-1 (4x)"
ITEM.model = Model("models/weapons/arccw/mifl_atts/fas2_optic_pso1.mdl")
ITEM.description = "Российский прицел с адаптером для установки на большинство оружий"
--ITEM.category = "Weapon Attachments"
ITEM.width = 1
ITEM.height = 1
ITEM.uniqueID = "mifl_fas2_optic_pso1"


ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(0.87822657823563, 12.366500854492, 0.97315901517868),
	ang = Angle(0, 270, 0),
	fov = 45
}

--ITEM.attname = "mifl_fas2_optic_pso1"

-- function ITEM:OnInstanced(index, x, y, item)
--     self:SetData("attname", self.attname)
-- end