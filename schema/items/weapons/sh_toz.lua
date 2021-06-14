ITEM.name = "Ружье 'ТОЗ'"
ITEM.description = "Двуствольное ружье с прикладом, позволяющее стрелять точно на длинную дистанцию"
ITEM.class = "arccw_mifl_fas2_toz34"
ITEM.weaponCategory = "primary"
ITEM.durability = 100
ITEM.uniqueID = "toz"

ITEM.model = "models/weapons/arccw/mifl/fas2/c_toz34.mdl"
ITEM.width = 4
ITEM.height = 1

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(21.970838546753, 89.642181396484, -8.0248327255249),
	ang = Angle(0, 270, 0),
	fov = 45
}

-- if (SERVER) then
--     util.AddNetworkString("ixOnEquipWeapon")
-- end

-- if (CLIENT) then
--     net.Receive("ixOnEquipWeapon", function()
--         local weapon = LocalPlayer():GetActiveWeapon()
--         print(weapon)
--         local attlist = net.ReadTable()
--         if (!table.IsEmpty(attlist)) then
--             for k,v in pairs(attlist) do
--                 weapon:Attach(k, v)
--             end
--         end
--     end)
-- end

-- function ITEM:OnEquipWeapon(client, weapon)
--     timer.Simple(0.5, function()
--         local attlist = weapon.ixItem:GetData("attachments", {}) 
--         print("attlist:")
--         PrintTable(attlist)
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

-- function ITEM:OnInstanced(index, x, y, item)
--     self:SetData("durability", self:GetData("durability") or self.durability or 66)
--     self:SetData("attachments", self.defaultAtt)
--     self:SetData("class", self.class)
-- end