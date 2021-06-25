ITEM.name = "Lootbox Base"
ITEM.model = "models/black1dez/olr/dez_box_metall_01.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Container with somethin inside"
ITEM.category = "Container"

ITEM.openingSounds = {
    "loot/woodcrack1.mp3",
    "loot/woodcrack2.mp3",
    "loot/woodcrack3.mp3"
}
ITEM.searchTime = 4
ITEM.items = {};

ITEM.functions.take.OnCanRun = function()
    return false
end

ITEM.OnEntityTakeDamage = function(self, damageInfo)
    return false
end

ITEM.functions.Open = {
    name = "Открыть",
    OnRun = function(item)
        local client = item.player
        if (!client:GetCharacter():GetInventory():HasItem("crowbar")) then
            client:Notify("Нужен лом или гвоздодер")
            return false
        end

        if (item:GetData("receiver") != nil) then
            client:Notify("Кто-то уже открывает")
            return false
        end
        item:SetData("receiver", client)
        local sound = Sound(item.openingSounds[math.random(1, #item.openingSounds)])
        item.searchTime = NewSoundDuration(sound)
        client:EmitSound(sound)
        client:SetAction("Открытие...", item.searchTime)
        item.openingTimer = "ixItemTimer"..item:GetEntity():GetCreationID()
        local phys = item:GetEntity():GetPhysicsObject()
        local mass = phys:GetMass() 
        timer.Create(item.openingTimer, item.searchTime/4, 0, function()
            if (!IsValid(item:GetEntity())) then
                timer.Remove(item.openingTimer)
                return
            end
            item:GetEntity():EmitSound("physics/wood/wood_crate_impact_hard"..math.random(1,5)..".wav")
            local force = Vector(0, 0, mass * (10 + 50))
            local offset = (item:GetEntity():GetPos() + Vector(math.random(-1,1) * 5, math.random(-1,1) * 4, 0))
            phys:ApplyForceOffset(force, offset)
        end)
        client:DoStaredAction(item:GetEntity(), 
            function()
                client:Notify("You have opened the box")
                local uid = item.items[math.random(1, #item.items)]
                ix.item.Spawn(uid, item:GetEntity():GetPos() + Vector(0, 0, 10), function(item_after, entity)
                    local phys = entity:GetPhysicsObject()
                    local force = Vector(0, 0,  phys:GetMass() * (10 + 150))
                    phys:ApplyForceCenter(force)
                end)
                item:GetEntity():EmitSound("physics/wood/wood_crate_impact_hard"..math.random(1,5)..".wav")
                item:GetEntity():Remove()
                item:SetData("receiver", nil)
                return true;
            end,
            item.searchTime,
            function()
                client:Notify("Look at the box!")
                client:SetAction()
                item:SetData("receiver", nil)
                client:StopSound(sound)
                timer.Remove(item.openingTimer)
                return false
            end)
        return false
    end,
    OnCanRun = function(item)
        return true
    end
}
