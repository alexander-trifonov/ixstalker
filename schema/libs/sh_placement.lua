ix.placement = ix.placement or {}

-- Prop lifetime: ghost -> frame -> prop -> despawn
-- ghost: on this stage, player is choosing where to place the prop
-- frame: places the prop, register, make it semi-transparent and waits for materials to build
-- prop: alive prop/entity
-- despawn: process of despawning the prop


function ix.placement.PlaceEntity(client, ent, prop_table)
    local data = {};
    data.Model = "models/props_borealis/bluebarrel001.mdl";
    client:SetNWString("ixPlacementModel", data.Model);
    client:Give("ix_placement");
    client:SelectWeapon("ix_placement")
end

do
    -- local playerMeta = FindMetaTable("Player")
    -- function playerMeta:SetPlacementData(data)
    --     self.placementData = data;
    -- end

    -- function playerMeta:GetPlacementData()
    --     return self.placementData
    -- end

    ix.command.Add("placeEntity", {
        description = "Place entity",
        superAdminOnly = true,
        arguments = {},
        OnRun = function(self, client, name, model, description)
            ix.placement.PlaceEntity(client, nil, nil)
        end
    })
end

-- if (CLIENT) then
--     -- Draws prop ghost on position for client
--     function ix.placement.DrawProp(prop)
--         local position = nil;
--         local ent = CreateClientside("prop_physics");
--         ent:SetModel(prop);
        
--         hook.Add("Think", "ixPlacementDrawProp", function()
--             ent:SetPos(LocalPlayer():GetEyeTrace().HitPos);
--             if (input.IsKeyDown(KEY_E)) then
--                 hook.Run("ixPlacementDrawPlaceFrame", ent:GetPos())
--                 --return ent:GetPos();
--                 --hook.Remove("ixPlacementDrawProp")
--             end
--         end)
--     end
--     -- Allows control to choose position  for the entity and build it
-- end

-- if (SERVER) then
--     util.AddNetworkString("ixPlacementPlaceFrame")
--     net.Receive("ixPlacementPlaceFrame", function(length, client)
--         -- create prop in the world
--     end)
-- end