ITEM.name = "Guitar"
ITEM.model = Model("models/se_ex/dev_gitara.mdl")
ITEM.description = "Penis guitar"
ITEM.category = "Consumables"
ITEM.width = 2 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1
ITEM.uniqueID = "guitar"

ITEM.noBusiness = true

local styles = {};
styles.bandit = {
    ["intro"] = {
        "bandit/talk/intros/intro_music_1.ogg.mp3",
        "bandit/talk/intros/intro_music_2.ogg.mp3",
        "bandit/talk/intros/intro_music_3.ogg.mp3",
        "bandit/talk/intros/intro_music_4.ogg.mp3"
    }
}
styles.stalker = {
    ["intro"] = {
        "stalker/talk/intros/intro_music_1.ogg.mp3",
        "stalker/talk/intros/intro_music_2.ogg.mp3",
        "stalker/talk/intros/intro_music_3.ogg.mp3",
        "stalker/talk/intros/intro_music_4.ogg.mp3"
    }
}

local music = {
    ["chill"] = {
        "guitar/chill/guitar_1.ogg.mp3",
        "guitar/chill/guitar_2.ogg.mp3",
        "guitar/chill/guitar_3.ogg.mp3",
        "guitar/chill/guitar_4.ogg.mp3",
        "guitar/chill/guitar_5.ogg.mp3"
    },
    ["acords"] = {
        "guitar/acords/guitar_1.ogg.mp3",
        "guitar/acords/guitar_2.ogg.mp3",
        "guitar/acords/guitar_3.ogg.mp3",
        "guitar/acords/guitar_4.ogg.mp3",
        "guitar/acords/guitar_5.ogg.mp3",
        "guitar/acords/guitar_6.ogg.mp3",
        "guitar/acords/guitar_7.ogg.mp3",
        "guitar/acords/guitar_8.ogg.mp3"
    }
}

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
        ix.gestures.Play(client, "g_preraid_beckonapexarms", false)

        item:SetData("ent", ent, client)
        client:EmitSound(Sound("physics/cardboard/cardboard_box_impact_soft7.wav"))
        -- ix.gestures.Play(client, "g_lookatthis", false)
        
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
        if (client:GetData("sound")) then
            client:StopSound(client:GetData("sound"))
        end 
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
	end
}

if (SERVER) then
    util.AddNetworkString("ixPlayMusic")
    net.Receive("ixPlayMusic", function(length, client)
        local data = net.ReadTable()
        PrintTable(data)
        --data.item:PlayMusic(client, "stalker", data.name)
    end)
end

if (SERVER) then
    net.Receive("ixPlayMusic", function(length, client)
        local data = net.ReadTable()
        local style = "stalker"
        local genre = data.genre
        if (styles[style] == nil) or (music[genre] == nil) then
            return false
        end
        if (client:GetData("sound")) then
            client:StopSound(client:GetData("sound"))
        end
        local intro = Sound(styles[style].intro[math.random(1, #styles[style].intro)])
        client:EmitSound(intro)
        client:SetData("sound", intro)
        timer.Simple(NewSoundDuration(intro), function()
            local sound = Sound(music[genre][math.random(1, #music[genre])])
            client:EmitSound(sound)
            client:SetData("sound", sound)
            timer.Simple(NewSoundDuration(sound), function()
                local entities = ents.FindInSphere(client:GetPos(), 250)
                for k,v in pairs(entities) do
                    if (v:IsPlayer()) then
                        v:ChatNotify("Вы послушали гитару, и вам стало теплее на душе")
                    end
                end
            end)
        end)
    end)
end

ITEM.functions.Play = {
    name = "Сыграть",
    isMulti = true,
    multiOptions = {
        {
            name = "Chill",
            OnClick = function(item)
                -- How to NOT do it:
                --item:GetOwner():SetData("genre", "chill") -- player:Setdata/character:setData is serversides only
                --item.music = "chill" - server doesn't see
                --item:SetData("genre", "chill", false) - doesn't setData on server

                local data = {}
                data.genre = "chill"
                net.Start("ixPlayMusic")
                net.WriteTable(data)
                net.SendToServer()
            end
        },
        {
            name = "Acords",
            OnClick = function(item) 
                local data = {}
                data.genre = "acords"
                net.Start("ixPlayMusic")
                net.WriteTable(data)
                net.SendToServer()
            end
        }
    },
	OnRun = function(item)
		local client = item.player
        --ix.gestures.Play(client, "g_lookatthis", false)
        --g_preraid_beckonlooparms
		-- ix.gestures.Play(client, "g_preraid_beckonapexarms", false)
		
        return false
	end,
    OnCanRun = function(item)
        return IsValid(item:GetOwner()) and (item:GetData("ent") != nil)
	end
}

ITEM.postHooks.drop = function(item, result)
    local ent = item:GetData("ent")
    if (IsValid(ent)) then
        ent:Remove()
        item:SetData("ent", nil)
    end
    local client = item.player
    if (client:GetData("sound")) then
        client:StopSound(client:GetData("sound"))
    end
    ix.gestures.Play(item.player, "idlenoise", true)
end
    