ix.playsound = ix.playsound or {}

function ix.playsound.Play(entity, sound, interrupt)
	interrupt = interrupt or true
    if (interrupt) then
        ix.playsound.Stop(entity)
    end
    entity:SetData("sound", sound)
    entity:EmitSound(sound)
    local uid = sound..math.random(1, 1000)
    entity:SetData("soundID", uid)
    return uid
end

-- stops last sound
-- to do: store sounds in table and do a loop
function ix.playsound.Stop(entity)
    if (entity:GetData("sound")) then
        entity:StopSound(entity:GetData("sound"))
        entity:SetData("soundID", nil)
        entity:SetData("sound", nil)
    end
end
