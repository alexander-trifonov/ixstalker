
PLUGIN.name = 'Corpse butchering'
PLUGIN.author = 'Bilwin'
PLUGIN.schema = 'Any'
PLUGIN.license = [[
    This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.
    In jurisdictions that recognize copyright laws, the author or authors
    of this software dedicate any and all copyright interest in the
    software to the public domain. We make this dedication for the benefit
    of the public at large and to the detriment of our heirs and
    successors. We intend this dedication to be an overt act of
    relinquishment in perpetuity of all present and future rights to this
    software under copyright law.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
    For more information, please refer to <http://unlicense.org/>
]]

ix.CorpseButchering = {
    --[[
    ['modelpath/modelname.mdl'] = {
        butcheringTime = 5,                                                                     -- How many seconds will the corpse be butchered
        impactEffect = "AntlionGib",                                                            -- What will be the effect when butchering a corpse
        slicingSound = {[1] = "soundpath/soundname.***", [2] = "soundpath/soundname.***"},      -- [1] This is the initial butchering sound; [2] this is the sound at which the corpse will already be butchered
        butcheringWeapons = {'weapon_class', 'weapon_class2'},                                  -- Weapons available for butchering a specific corpse
        animation = "Roofidle1",                                                                -- Animation that will be played when butchering
        items = {'item_uniqueID1', 'item_uniqueID2'}                                            -- Items to be issued for character after butchered
    }
    --]]
    ['models/Lamarr.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/headcrabclassic.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/headcrabblack.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/headcrab.mdl'] = {
        butcheringTime = 5,
        items = {}
    },
    ['models/antlion.mdl'] = {
        impactEffect = 'AntlionGib',
        butcheringTime = 30,
        slicingSound = {[1] = 'ambient/machines/slicer2.wav', [2] = 'ambient/machines/slicer3.wav'},
        items = {}
    },
    ['models/wick/dog/wick_blind_dog.mdl'] = {
        butcheringTime = 5,
        butcheringWeapons = {"ix_hands"},
        items = {"dog_tail"}
    },
    ['models/wick/krovo/krovosos_little.mdl'] = {
        butcheringTime = 15,
        butcheringWeapons = {"ix_hands"},
        items = {"krovosos_jaw"}
    },
    ['models/wick/krovo/wick_krovosos.mdl'] = {
        butcheringTime = 15,
        butcheringWeapons = {"ix_hands"},
        items = {"krovosos_jaw"}
    }
}

if (SERVER) then
    ix.log.AddType("playerButchered", function(pl, corpse)
        return string.format("%s was butchered %s.", pl:Name(), corpse:GetModel())
    end)

    util.AddNetworkString("ixClearClientRagdolls")

    -- Works! Need to set blood color for every fucking npc from stalker
    -- function PLUGIN:PlayerSpawnedNPC(player, entity)
    --     print("asdasdadsdasdasadsasd")
    --     entity:SetBloodColor(BLOOD_COLOR_RED)
    -- end

    function PLUGIN:CreateEntityRagdoll(owner, ragdoll)
        if (ix.CorpseButchering[owner:GetModel()]) then
            ragdoll:Remove()
        end
    end

	function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
        if IsValid(npc) and ix.CorpseButchering[npc:GetModel()] then
            --npc:SetShouldServerRagdoll(false)
            local ragdoll = ents.Create("prop_ragdoll")
            timer.Simple(30, function()
                ragdoll:Remove()
            end)
            ragdoll:SetPos( npc:GetPos() )
            ragdoll:SetAngles( npc:EyeAngles() )
            ragdoll:SetModel( npc:GetModel() )
            ragdoll:SetSkin( npc:GetSkin() )

            for i = 0, (npc:GetNumBodyGroups() - 1) do
                ragdoll:SetBodygroup(i, npc:GetBodygroup(i))
            end

            ragdoll:Spawn()
            ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            ragdoll:Activate()

            local velocity = npc:GetVelocity()

            for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
                local physObj = ragdoll:GetPhysicsObjectNum(i)

                if ( IsValid(physObj) ) then
                    physObj:SetVelocity(velocity)

                    local index = ragdoll:TranslatePhysBoneToBone(i)

                    if (index) then
                        local position, angles = npc:GetBonePosition(index)

                        physObj:SetPos(position)
                        physObj:SetAngles(angles)
                    end
                end
            end

            net.Start("ixClearClientRagdolls")
                net.WriteString(npc:GetModel())
            net.Broadcast()
        end
	end

    function PLUGIN:KeyPress(pl, key)
        if ( pl:GetCharacter() and pl:Alive() ) then
            if ( key == IN_USE ) then
                local HitPos = pl:GetEyeTraceNoCursor()
                local target = HitPos.Entity
                if target and IsValid(target) and target:IsRagdoll() and ix.CorpseButchering[target:GetModel()] then
                    local allowedWeapons = istable(ix.CorpseButchering[target:GetModel()].butcheringWeapons) and ix.CorpseButchering[target:GetModel()].butcheringWeapons or {'weapon_crowbar'}
                    local canButchering = hook.Run('CanButchering', pl, target)
                    if ( table.HasValue(allowedWeapons, pl:GetActiveWeapon():GetClass()) and !target:GetNetVar('cutting', false) and canButchering ) then
                        local butcheringAnimation = isstring(ix.CorpseButchering[target:GetModel()].animation) and ix.CorpseButchering[target:GetModel()].animation or "Roofidle1"
                        pl:ForceSequence(butcheringAnimation, nil, 0)
                        target:SetNetVar('cutting', true)
                        target:EmitSound( (istable(ix.CorpseButchering[target:GetModel()].slicingSound) and ix.CorpseButchering[target:GetModel()].slicingSound[1]) or "ambient/machines/slicer1.wav" )

                        local physObj, butcheringTime = target:GetPhysicsObject(), isnumber(ix.CorpseButchering[target:GetModel()].butcheringTime) and ix.CorpseButchering[target:GetModel()].butcheringTime or 2

                        if ( IsValid(physObj) and !isnumber(ix.CorpseButchering[target:GetModel()].butcheringTime) ) then
                            butcheringTime = math.Round( physObj:GetMass() )
                        end

                        pl:SetAction("??????????????????????...", butcheringTime)
                        pl:DoStaredAction(target, function()
                            if ( IsValid(pl) ) then
                                pl:LeaveSequence()

                                if IsValid(target) then
                                    target:SetNetVar('cutting', nil)
                                    target:EmitSound( (istable(ix.CorpseButchering[target:GetModel()].slicingSound) and ix.CorpseButchering[target:GetModel()].slicingSound[2] or "ambient/machines/slicer4.wav") )

                                    local effect = EffectData()
                                        effect:SetStart(target:LocalToWorld(target:OBBCenter()))
                                        effect:SetOrigin(target:LocalToWorld(target:OBBCenter()))
                                        effect:SetScale(3)
                                    util.Effect(ix.CorpseButchering[target:GetModel()].impactEffect or "BloodImpact", effect)

                                    local butcheringItems = istable(ix.CorpseButchering[target:GetModel()].items) and ix.CorpseButchering[target:GetModel()].items or {}
                                    if !table.IsEmpty(butcheringItems) then
                                        for _, item in ipairs( butcheringItems ) do
                                            pl:GetCharacter():GetInventory():Add(item)
                                        end
                                    end

                                    ix.log.Add(pl, "playerButchered", target)
                                    hook.Run('OnButchered', pl, target)
                                    target:Remove()
                                end
                            end
                        end, butcheringTime, function()
                            if ( IsValid(pl) ) then
                                pl:SetAction()
                                pl:LeaveSequence()
                                target:SetNetVar('cutting', false)
                            end
                        end)
                    end
                end
            end
        end
    end

    function PLUGIN:CanButchering(pl, target)
        return true
    end
end