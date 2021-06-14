ITEM.name = "Обрез"
ITEM.description = "Двуствольное ружье с обрезанным стволом, без приклада для большей мобильности"
ITEM.class = "arccw_mifl_fas2_toz34"
ITEM.weaponCategory = "primary"
ITEM.durability = 100
ITEM.uniqueID = "obrez"

ITEM.model = "models/weapons/arccw/mifl/fas2/c_toz34.mdl"
ITEM.width = 2
ITEM.height = 1

ITEM.defaultAtt = {
    [4] = "mifl_fas2_toz_bar_2x_s",
    [7] = "mifl_fas2_ks23_stock_k"
}

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(20.207563400269, 34.620037078857, -7.3848528862),
	ang = Angle(0, 270, 0),
	fov = 45
}


-- ITEM.exRender = true
-- ITEM.iconCam = {
-- 	ang = Angle(0, 270, 0),
-- 	fov = 45,
-- 	pos = Vector(18.761362075806, 14.186038970947, -4.5903964042664)
-- }

-- if (SERVER) then
--     util.AddNetworkString("ixOnEquipWeapon")
-- end

-- if (CLIENT) then
--     net.Receive("ixOnEquipWeapon", function()
--         local weapon = LocalPlayer():GetActiveWeapon()
--         local attlist = net.ReadTable()
--         if (!table.IsEmpty(attlist)) then
--             for k,v in pairs(attlist) do
--                 weapon:Attach(k, v)
--             end
--         end
--     end)
-- end

-- function ITEM:OnEquipWeapon(client, weapon)
--     print(self.base)
--     print(self:GetData("class"))
--     timer.Simple(0.5, function()
--         local attlist = weapon.ixItem:GetData("attachments", {}) 
--         net.Start("ixOnEquipWeapon")
--             net.WriteTable(attlist)
--         net.Send(client)
--         if (!table.IsEmpty(attlist)) then
--             for k,v in pairs(attlist) do
--                 weapon:Attach(k, v)
--             end
--         end
    
--     end)
-- end

-- function ITEM:PostInstanced(index, x, y, item)
--     self:SetData("durability", self:GetData("durability") or self.durability or 66)
--     self:SetData("attachments", self.defaultAtt)
--     self:SetData("class", self.class)
-- end