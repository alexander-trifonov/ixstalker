ITEM.name = "Artifacts Base"
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Artifact"
ITEM.category = "Artifacts"
ITEM.bDropOnDeath = true


function ITEM:OnEntityCreated(ent)
    if (ent:GetData("isFound", false)) then return end
    ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
    ent:SetColor(Color(255, 255, 255, 0))
    self:SetData("isFound", false)
end

if (SERVER) then
    util.AddNetworkString("ixFoundArtifact")
    net.Receive("ixFoundArtifact", function(length, client)
        local item = net.ReadEntity()
        local found = net.ReadBool()
        item = ix.item.instances[item.ixItemID] -- i don't really like it, but I can't send the entity to server for some reason -_-
        if (item != nil) then
            if (found) then
                item:SetData("isFound", true)
                item:GetEntity():SetColor(Color(255, 255, 255, 255))
            else
                item:SetData("isFound", false)
                item:GetEntity():SetColor(Color(255, 255, 255, 0))
            end
        end
    end)
end

ITEM.functions.take.OnCanRun = function(item)
   return item:GetData("isFound") 
end