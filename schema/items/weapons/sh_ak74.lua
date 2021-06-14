ITEM.name = "Автомат АК-74"
ITEM.description = "Тест"
ITEM.class = "arccw_mifl_fas2_ak47"
ITEM.weaponCategory = "primary"
ITEM.durability = 100
ITEM.uniqueID = "arccw_mifl_fas2_ak47"

ITEM.model = "models/weapons/arccw/mifl/fas2/c_m1911.mdl"
ITEM.width = 1
ITEM.height = 1
-- ITEM.exRender = true
-- ITEM.iconCam = {
-- 	ang = Angle(0, 270, 0),
-- 	fov = 45,
-- 	pos = Vector(18.761362075806, 14.186038970947, -4.5903964042664)
-- }

if (SERVER) then
    util.AddNetworkString("ixOnEquipWeapon")
end

if (CLIENT) then
    net.Receive("ixOnEquipWeapon", function()
        local weapon = LocalPlayer():GetActiveWeapon()
        print(weapon)
        local attlist = net.ReadTable()
        if (!table.IsEmpty(attlist)) then
            for k,v in pairs(attlist) do
                weapon:Attach(k, v)
            end
        end
    end)
end

function ITEM:OnEquipWeapon(client, weapon)
    timer.Simple(0.5, function()
        local attlist = weapon.ixItem:GetData("attachments", {}) 
        print("attlist:")
        PrintTable(attlist)
        net.Start("ixOnEquipWeapon")
            net.WriteTable(attlist)
        net.Send(client)
        if (!table.IsEmpty(attlist)) then
            for k,v in pairs(attlist) do
                weapon:Attach(k, v)
            end
        end
    
    end)
end

function ITEM:OnInstanced(index, x, y, item)
    self:SetData("durability", self:GetData("durability") or self.durability or 66)
end