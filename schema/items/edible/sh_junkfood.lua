-- g_fist_r
ITEM.name = "Junkfood"
ITEM.base = "base_edible"
ITEM.model = Model("models/props_junk/garbage_metalcan002a.mdl")
ITEM.description = "Something edible"
ITEM.category = "Consumables"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

ITEM.tools = {
    "spoon"
}

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
        pos, angle = LocalToWorld(Vector(3.5, -3, -3.3), Angle(0, 0, 0), pos, angle)
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
            client:ChatNotify("Вам нужна ложка") -- too lazy to automate it.. probably later
            return false
        end
        --  EAT OM-NOM-NOM
        PrintTable(item)
        item:TakeInHands()
        --item.functions.TakeInHands()
        ix.gestures.Play(client, "g_fist_r", true)
        return false
    end
}
