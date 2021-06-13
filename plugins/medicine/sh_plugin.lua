PLUGIN.name = "Medicine attribute"
PLUGIN.author = "Mobious"
PLUGIN.description = "Determines effectivness of healing player and others"


function PLUGIN:healCalculate(client, threshold, target)
    if (target == nil) then
        target = client
    end
    client:EmitSound("physics/cardboard/cardboard_box_strain1.wav")
    if (client:GetCharacter():GetAttribute("medicine", 0) <= threshold) then
        client:ChatNotify("Из-за низкого навыка медицины, вы сделали только хуже")
        if (!target:IsFemale()) then
            target:EmitSound("vo/npc/male01/pain0"..math.random(7,9)..".wav")
        else
            target:EmitSound("vo/npc/female01/pain0"..math.random(1,3)..".wav")            
        end
        return -10;
    end
    return client:GetCharacter():GetAttribute("medicine")
end