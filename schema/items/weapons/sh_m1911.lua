ITEM.name = "Пистолет M1911"
ITEM.description = "Второстепенное оружие американского производства, магазин вмещает 7 патронов"
ITEM.class = "arccw_mifl_fas2_m1911"
ITEM.weaponCategory = "sidearm"
ITEM.durability = 100
ITEM.uniqueID = "m1911"
ITEM.bDropOnDeath = true

ITEM.model = "models/weapons/arccw/mifl/fas2/c_m1911.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.exRender = true
ITEM.iconCam = {
	ang = Angle(0, 270, 0),
	fov = 45,
	pos = Vector(18.761362075806, 14.186038970947, -4.5903964042664)
}


-- function ITEM:OnInstanced(index, x, y, item)
--     self:SetData("durability", self:GetData("durability") or self.durability or 66)
-- 	self:SetData("class", self.class)
-- end
