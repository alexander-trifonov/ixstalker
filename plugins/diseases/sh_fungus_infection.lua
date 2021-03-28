local DISEASE = {}
DISEASE.name = "Fungus Infection"
DISEASE.uid = "fungus_infection"
DISEASE.description "You will die :)"

function DISEASE:OnPlayerChat(ply, text, teamchat, isDead)
    ply:Notify("Can't breath")    
end

