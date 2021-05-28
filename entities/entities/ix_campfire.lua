AddCSLuaFile();

ENT.Type = "anim";
--ENT.Base = "base_gmodentity";

ENT.Category = "Stalker";
ENT.PrintName = "Campfire";
ENT.Spawnable = true;
ENT.AdminOnly = false;

ENT.LightSize = 256-64-32;
ENT.LightColor = Color(255, 192, 64);
ENT.ExtinguishAmount = 4;

//ENT.bNoPersist = true;
//ENT.ShowPlayerInteraction = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Enabled");
	self:NetworkVar("Float", 0, "Power");
end;

if (SERVER) then
	function ENT:SpawnFunction(client, trace, class)
		local entity = ents.Create(class);
		entity:SetPos(trace.HitPos);
		entity:Spawn();
		entity:Activate();

		return entity;
	end;

	function ENT:Initialize()
		self:SetModel("models/props_unique/firepit_campground.mdl");
		self:SetSolid(SOLID_VPHYSICS);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON);
		self:SetUseType(SIMPLE_USE);

		// Fire
		self.fire = ents.Create("prop_dynamic");
		self.fire:SetPos(self:GetPos());
		self.fire:SetModel("models/props_junk/PopCan01a.mdl");
		self.fire:SetModelScale(0.1, 0);
		self.fire:SetAngles(self:GetAngles());
		self.fire:SetParent(self);
		self.fire:SetNoDraw(true);
		self.fire:Spawn();

		self.nextUse = 0;
		self.putoutSteps = 1 + math.random(self.ExtinguishAmount);

		local physics = self:GetPhysicsObject();
		physics:EnableMotion(false);
	end;

	function ENT:Use(activator)
		if (CurTime() < self.nextUse) then return end;

		if (self:GetEnabled()) then
			self:PutOut(activator);
		else
			self:Kindle(activator);
		end;
	end;

	function ENT:Kindle(client)
		if self:GetEnabled() then return end;

		self:SetEnabled(true);

		self.fire:Ignite(1024*1024, 5);
		
		self:SetPower(CurTime()+0.66);

		self:EmitSound("ambient/fire/mtov_flame2.wav", 60, math.random(94, 106));
		client:ViewPunch(Angle(4, 0, 0));

		self.nextUse = CurTime() + 2;
		self.putoutSteps = 1 + math.random(self.ExtinguishAmount);	
	end;

	function ENT:PutOut(client)
		if !self:GetEnabled() then return end;

		// Fake step
		self:EmitSound("player/footsteps/gravel"..math.random(1, 4)..".wav", 70, math.random(72, 86));
		client:ViewPunch(Angle(4, 0, 0));

		self.nextUse = CurTime() + 0.66;
		self.putoutSteps = self.putoutSteps - 1;

		// Extinguish and disable
		if (self.putoutSteps <= 0) then
			self:SetEnabled(false);

			self.fire:Extinguish();
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav", 48, math.random(166, 222), 44);
	
			self.nextUse = CurTime() + 2;
		end;
	end;

	function ENT:OnRemove()
		if (self.fire) then
			self.fire:Extinguish();
			self.fire:Remove();
		end;
	end;

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS;
	end;
else
	function ENT:Think()
		if (!self:GetEnabled()) then return end;

		local light = DynamicLight(self:EntIndex());
		if (light) then
			light.pos = self:GetPos()+Vector(0, 0, 16);
			light.r = self.LightColor.r;
			light.g = self.LightColor.g;
			light.b = self.LightColor.b;
			light.brightness = 2;
			light.Size = (1-math.max(0, self:GetPower()-CurTime()))*(self.LightSize+(math.random(-4, 4))+(16*math.sin(1*CurTime())));
			light.Decay = 256;
			light.DieTime = CurTime() + 1;
		end;
	end;
end;
