
ITEM.name = "Edible Base"
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Something edible"
ITEM.category = "Consumables"
ITEM.bDropOnDeath = true
ITEM.isDrink = false
ITEM.thirstGain = 0
ITEM.hungerGain = 0

ITEM.tools = {
    -- "spoon",
    -- "cup"
}


if (CLIENT) then
    function ITEM:PopulateTooltip(tooltip)
        if (self:GetData("uses", self.uses)) then
            local uses = tooltip:AddRow("sign")
            local text = "Осталось: "..self:GetData("uses", self.uses)--.."\n"..self:GetDescription()
            uses:SetColor(Color(255, 150, 20))
            uses:SetText(text or "")
	        uses:SizeToContents()
        end
    end
end

function ITEM:TakeInHands()
    local client = self.player

        local ent = ents.Create("prop_physics")
        local handID = client:LookupBone("ValveBiped.Bip01_R_Hand")
        ent:SetModel(self.model)
        ent:FollowBone(client, handID)
        local pos, angle = client:GetBonePosition(handID)
        -- Get proper position
        pos, angle = LocalToWorld(Vector(3.5, -3, -3.3), Angle(0, 0, 0), pos, angle)
        -- Get proper angle
        angle = Angle(0,0,0)
        angle:RotateAroundAxis(angle:Right(), 180)
        ent:SetPos(pos)
        ent:SetAngles(angle)

        timer.Simple(2, function()
            ent:Remove()
            --ix.gestures.Play(client, "hg_nod_yes")
        end)
end

ITEM.functions.TakeInHands = {
    name = "Взять в руки",
	OnRun = function(item)
		local client = item.player

        local ent = ents.Create("prop_physics")
        local handID = client:LookupBone("ValveBiped.Bip01_R_Hand")
        ent:SetModel(item.model)
        ent:FollowBone(client, handID)
        local pos, angle = client:GetBonePosition(handID)
        -- Get proper position
        pos, angle = LocalToWorld(item.pos or Vector(3.5, -3, -3.3), Angle(0, 0, 0), pos, angle)
        -- Get proper angle
        angle = Angle(0,0,0)
        angle:RotateAroundAxis(angle:Right(), 180)
        ent:SetPos(pos)
        ent:SetAngles(angle)

        timer.Simple(5, function()
            ent:Remove()
            --ix.gestures.Play(client, "hg_nod_yes")
        end)
		return false
	end
}

ITEM.functions.Eat = {
    name = "Съесть",
    OnRun = function(item)
        local client = item.player
        if (!client:GetCharacter():GetInventory():HasItems(item.tools)) then
            local text = ""
            for k,v in pairs(item.tools) do
                text = text.." "..ix.item.Get(v):GetName()
                if (k != #item.tools) then
                    text  = text..","
                end
            end
            client:ChatNotify("Вам нужно иметь: "..text) -- too lazy to automate it.. probably later
            return false
        end
        --  EAT OM-NOM-NOM
        item:TakeInHands()
        if (item.isDrink) then
            client:EmitSound("consumables/inv_softdrink"..math.random(1,2)..".ogg.mp3", 65)
        else
            client:EmitSound("consumables/inv_food"..math.random(1,2)..".ogg.mp3", 65)
        end
        client:SetThirst(client:GetThirst() + item.thirstGain)
        client:SetHunger(client:GetHunger() + item.hungerGain)
        ix.gestures.Play(client, "g_fist_r", true)

        if (item.uses) then
            print(item:GetData("uses"))
            if (item:GetData("uses", item.uses) > 1) then
                item:SetData("uses", item:GetData("uses", item.uses) - 1)
                print(item:GetData("uses"))
                return false
            end
        end
        return true
    end
}