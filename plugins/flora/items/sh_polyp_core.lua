ITEM.name = "Polyp Core"
ITEM.model = Model("models/gibs/antlion_gib_large_3.mdl")
ITEM.description = "A strange semihard organic matter with chloric taste"
ITEM.category = "Other"
ITEM.width = 1
ITEM.height = 1

function ITEM:OnEntityCreated(self)
    self:SetModelScale(0.5, 0)
    self:PhysicsInit(SOLID_VPHYSICS)
    --self:SetSolid(SOLID_VPHYSICS)
    --self:Activate()
    self:GetPhysicsObject():Wake()
end