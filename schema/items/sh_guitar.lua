ITEM.name = "Guitar"
ITEM.model = Model("models/se_ex/dev_gitara.mdl")
ITEM.description = "Penis guitar"
ITEM.category = "Consumables"
ITEM.width = 2 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1
ITEM.uniqueID = "guitar"

ITEM.noBusiness = true

ITEM.functions.TakeInHands = {
    name = "Взять в руки",
	OnRun = function(item)
		local client = item.player
        if (IsValid(item:GetData("ent"))) then  return false end
        local ent = ents.Create("prop_physics")
        local handID = client:LookupBone("ValveBiped.Bip01_Spine")
        ent:SetModel(item.model)
        ent:FollowBone(client, handID)
        local pos, angle = client:GetBonePosition(handID)
        -- Get proper position
        pos, angle = LocalToWorld(Vector(6, 8, 10), Angle(0, 0, 0), pos, angle)
        ent:SetPos(pos)
        angle = ent:SetLocalAngles(Angle(-60, 0, -100))

        --item.ent = ent
        --print(item.ent)
        print(ent)
        item:SetData("ent", ent, client)
        client:EmitSound(Sound("physics/cardboard/cardboard_box_impact_soft7.wav"))
        -- ix.gestures.Play(client, "g_lookatthis", false)
        
        -- timer.Simple(5, function()
        --     ix.gestures.Play(client, "g_armsout", true)
        --     ent:Remove()
        -- end)
		return false
	end,
    OnCanRun = function(item)
        return IsValid(item:GetOwner()) and (item:GetData("ent") == nil) --and item:GetData("entity")
	end
}

ITEM.functions.BackToInventory = {
    name = "Убрать",
	OnRun = function(item)
		local client = item.player
        local ent = item:GetData("ent")
        if (IsValid(ent)) then
            ent:Remove()
            client:EmitSound(Sound("physics/cardboard/cardboard_box_impact_soft4.wav"))
            ix.gestures.Play(client, "g_armsout", true)
            item:SetData("ent", nil)
        end
		return false
	end,
    OnCanRun = function(item)
		return IsValid(item:GetOwner()) and (item:GetData("ent") != nil)
        --if (IsValid(item.ent)) then return false end
	end
    
}

ITEM.functions.Play = {
    name = "Сыграть",
	OnRun = function(item)
		local client = item.player
        --ix.gestures.Play(client, "g_lookatthis", false)
        --g_preraid_beckonlooparms
		ix.gestures.Play(client, "g_preraid_beckonapexarms", false)
		
        return false
	end,
    OnCanRun = function(item)
		--if (!item:GetOwner()) then return false end
        print(item:GetData("ent"))
        return IsValid(item:GetOwner()) and (item:GetData("ent") != nil)
        --if (!IsValid(item.ent)) then return false end
	end
}

ITEM.postHooks.drop = function(item, result)
    local ent = item:GetData("ent")
    if (IsValid(ent)) then
        ent:Remove()
        item:SetData("ent", nil)
    end
    ix.gestures.Play(item.player, "idlenoise", true)
end
    