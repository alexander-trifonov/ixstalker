ITEM.name = "Junkfood"
--ITEM.base = "Weapons"
ITEM.model = Model("models/props_junk/garbage_metalcan002a.mdl")
ITEM.description = "Something edible"
ITEM.category = "Consumables"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

ITEM.noBusiness = true

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
