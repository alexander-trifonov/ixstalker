ix.placement = ix.placement or {}

-- Prop lifetime: ghost -> frame -> prop -> despawn
-- ghost: on this stage, player is choosing where to place the prop
-- frame: places the prop, register, make it semi-transparent and waits for materials to build
-- prop: alive prop/entity
-- despawn: process of despawning the prop


function ix.placement.PlaceEntity(client, data)
    local data = data or {};
    data.Entity = data.Entity or "ix_placeable"
    --client:GetCharacter():SetData("ixPlacementData", data);
    client:SetLocalVar("ixPlacementData", data)
    client:Give("ix_placement");
    client:SelectWeapon("ix_placement")
end

do
    local playerMeta = FindMetaTable("Player")
    function playerMeta:CanPlaceEntity(ItemUniqueID)
        return self:GetCharacter():GetInventory():HasItem(ItemUniqueID)      
    end

    ix.command.Add("placeEntity", {
        description = "Place entity",
        superAdminOnly = true,
        arguments = {},
        OnRun = function(self, client, name, model, description)
            ix.placement.PlaceEntity(client, nil)
        end
    })
end