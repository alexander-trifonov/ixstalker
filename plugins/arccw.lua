PLUGIN.name = "Arccw support"
PLUGIN.author = "Mobious"
PLUGIN.description = "Configs and additional code for arccw support"

if (SERVER) then
    RunConsoleCommand("arccw_mult_defaultammo", 0)
    RunConsoleCommand("arccw_enable_customization", 1)

    RunConsoleCommand("arccw_attinv_loseondie", 0)
    RunConsoleCommand("arccw_enable_dropping", 0)
    RunConsoleCommand("arccw_attinv_free", 1)
else
    RunConsoleCommand("arccw_autosave", 0)
end

local allowedSlots = {
    [1] = "optic"
}

-- temporary
ix.command.Add("cleanup", {
	description = "clean all entities",
	superAdminOnly = true,
	OnRun = function(self, client)
        local entities = ents.GetAll()
        for k, v in pairs(entities) do
            if (v:GetClass() == "ix_item") then
                v:Remove()
            end
        end
	end
})


-- При взятии оружия в руки, если в нем есть какая-то дата, она не сетается
-- При взятии оружия в руки, зачем-то аттачатся аттчменты которые находятся у игрока в "arccw инвентаре" - надо отключить инвентарь у арккв

function PLUGIN:ArcCW_PlayerCanAttach(client, wep, attname, slot, detach)
    print(attname, slot)
    local char = client:GetCharacter()
    local inventory = client:GetCharacter():GetInventory()
    -- local item_weapon = inventory:HasItem(wep:GetClass(), {
    --     ["equip"] = true
    -- })
    local item_weapon = inventory:HasItemOfBase("base_weapons", {
        ["equip"] = true,
        ["class"] = wep:GetClass()
    })

    if (item_weapon) then
        if (item_weapon.class != wep:GetClass()) then
            client:Notify("Сообщите администратору об ошибке")
            return false
        end
    else
        client:Notify("Оружие не найдено в инвентаре")
        return false
    end
    
    -- Perhaps
    if (item_weapon:GetData("attachments", {})[slot] == attname) then
        print("Trueeeee")
        return true
    end

    if (allowedSlots[slot] == nil) then
        return false
    end 
    
    local item_attachment = {}
    
    if (CLIENT) then
        if (attname == "") then
            detach = true
        end
    end
    if (!detach) then
        local weaponAttachments = item_weapon:GetData("attachments")
        if (weaponAttachments != nil) then
            -- Check maybe weapon already has it
            if (weaponAttachments[slot] == attname) then
                -- good, but we  still need to attach it, since this function is called by OnEquipWeapon
                return true
                --item_attachment.uniqueID = attname
            end
        end
        item_attachment = inventory:HasItem(attname)
        if (!item_attachment) then
            client:Notify("Подходящий аттачмент не найден в инвентаре")
            return false
        end
    end
    
    if (SERVER) then
        local attlist = item_weapon:GetData("attachments", {})
        if (detach) then
            if (attlist[slot] != nil)  then
                inventory:Add(attlist[slot])
            end
            attlist[slot] = nil
            item_weapon:SetData("attachments", attlist)
            return true
        end
        if (attlist[slot] != nil) then
            inventory:Add(attlist[slot])
        end
        attlist[slot] = item_attachment.uniqueID
        inventory:Remove(item_attachment:GetID())
        item_weapon:SetData("attachments", attlist)
    end
end