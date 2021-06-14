ITEM.name = "Автомат АКМ-74/2U"
ITEM.description = "Автомат Калашникова с укороченным стволом и облегченным прикладом. Средни недостатков - малая прицельная дальность"
ITEM.class = "arccw_mifl_fas2_ak47"
ITEM.weaponCategory = "primary"
ITEM.durability = 100
ITEM.uniqueID = "ak74u"

ITEM.model = "models/weapons/arccw/mifl/fas2/c_ak47.mdl"
ITEM.width = 4
ITEM.height = 2

ITEM.defaultAtt = {
    [2] = "mifl_fas2_ak_hg_u",
    [8] = "mifl_fas2_ak_stock_ske"
}

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(20.606443405151, 46.667194366455, -7.7285885810852),
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