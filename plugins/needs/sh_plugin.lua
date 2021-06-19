PLUGIN.name = "Another Needs System"
PLUGIN.author = "Mobious"
PLUGIN.description = "Hunger, thirst etc"

ix.command.Add("CharSetHunger", {
	adminOnly = true,
	arguments = {
		ix.type.player,
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, target, number)
        if !number then
            number = 100;
        end;

        target:SetHunger(number);
	end
})

ix.command.Add("CharSetThirst", {
	adminOnly = true,
	arguments = {
		ix.type.player,
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, target, number)
        if !number then
            number = 100;
        end;

        target:SetThirst(number);
	end
})

local painSounds = {
	Sound("vo/npc/male01/pain01.wav"),
	Sound("vo/npc/male01/pain02.wav"),
	Sound("vo/npc/male01/pain03.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/male01/pain05.wav"),
	Sound("vo/npc/male01/pain06.wav")
}
if (SERVER) then
    local playerMeta = FindMetaTable("Player")

    function playerMeta:SetHunger(number)
        -- local char = self:GetCharacter()
        -- char:SetData('hunger', number)
        self:SetLocalVar("hunger", math.Clamp(number, 0, 100))
        --self:ChatNotify("Setting hunger to "..self:GetHunger())
        hook.Run("ixOnSetHunger", self, number)
    end
    function playerMeta:GetHunger()
        return self:GetLocalVar("hunger", 50)
    end
    function PLUGIN:ixOnSetHunger(client, number)
        if (client:GetHunger() <= 5) then
            if (!client:GetLocalVar("LowHunger")) then
                client:SetLocalVar("LowHunger", true)
                local timerID = "ixLowHunger"..client:GetCreationID()
                timer.Create(timerID, 2, 0, function()
                    if ((client:GetHunger() > 5) or (!IsValid(client)) or (!client:Alive())) then
                        timer.Remove(timerID)
                        client:SetLocalVar("LowHunger", false)
                        return
                    end
                    client:ViewPunch(Angle(-5, 0, 0))
                    client:SetHealth(client:Health() - 1)
                    local painSound = hook.Run("GetPlayerPainSound", client) or painSounds[math.random(1, #painSounds)]

                    if (client:IsFemale() and !painSound:find("female")) then
                        painSound = painSound:gsub("male", "female")
                    end

                    client:EmitSound(painSound)
                    if (client:Health() <= 0) then
                        client:Kill()
                    end
                end
                )
            end
        else
            if (client:GetLocalVar("LowHunger") == true) then
                client:SetLocalVar("LowHunger", false)
            end
        end
    end

    function playerMeta:SetThirst(number)
        -- local char = self:GetCharacter()
        --self:SetData('thirst', number)
        self:SetLocalVar("thirst", math.Clamp(number, 0, 100))
        hook.Run("ixOnSetThirst", self, number)
    end
    function playerMeta:GetThirst()
        return self:GetLocalVar("thirst", 50)
    end
    function PLUGIN:ixOnSetThirst(client, number)
        if (client:GetThirst() <= 5) then
            if (!client:GetLocalVar("LowThirst")) then
                client:SetLocalVar("LowThirst", true)
                local timerID = "LowThirst"..client:GetCreationID()
                timer.Create(timerID, 2, 0, function()
                    if ((client:GetThirst() > 5) or (!IsValid(client)) or (!client:Alive())) then
                        timer.Remove(timerID)
                        client:SetLocalVar("LowThirst", false)
                        return
                    end
                    client:ViewPunch(Angle(-5, 0, 0))
                    client:SetHealth(client:Health() - 1)
                    local painSound = hook.Run("GetPlayerPainSound", client) or painSounds[math.random(1, #painSounds)]

                    if (client:IsFemale() and !painSound:find("female")) then
                        painSound = painSound:gsub("male", "female")
                    end

                    client:EmitSound(painSound)
                    if (client:Health() <= 0) then
                        client:Kill()
                    end
                end
                )
            end
        else
            if (client:GetLocalVar("LowThirst") == true) then
                client:SetLocalVar("LowThirst", false)
            end
        end
    end

    function PLUGIN:OnCharacterCreated(client, character)
        client:SetHunger(100)
        client:SetThirst(100)
        character:SetData("hunger", 100)
        character:SetData("thirst", 100)
        
    end

    function PLUGIN:PlayerLoadedCharacter(client, character)
        timer.Simple(0.25, function()
            client:SetHunger(character:GetData("hunger"))
            client:SetThirst(character:GetData("thirst"))
        end)
    end
    
    function PLUGIN:CharacterPreSave(character)
        local client = character:GetPlayer()
    
        if (IsValid(client)) then
            character:SetData("hunger", client:GetLocalVar("hunger"))
            character:SetData("thirst", client:GetLocalVar("thirst"))
        end
    end

    function PLUGIN:PlayerDeath(client, inflictor, attacker)
        client:SetHunger(50)
        client:SetThirst(50)
    end

    function PLUGIN:InitializedPlugins()
        self.Delay = CurTime() + ix.config.Get("ixNeedsThinkDelay", 1)
    end

    function PLUGIN:Think()
        if (CurTime() > self.Delay) then
            local players = player.GetAll()
            for k, v in pairs(players) do
                if (IsValid(v) and v:GetCharacter()) then
                    v:SetHunger(v:GetHunger() - ix.config.Get("ixNeedsHungerConsumes", 0.1))
                    v:SetThirst(v:GetThirst() - ix.config.Get("ixNeedsThirstConsumes", 0.2))
                end
            end
            self.Delay = CurTime() + ix.config.Get("ixNeedsThinkDelay", 1)
        end
    end
end

ix.config.Add("ixNeedsThinkDelay", 2, "How often the server will check player's hunger/thirst stats in seconds", nil, {
	data = {min = 1, max = 60},
	category = "Needs"
})

ix.config.Add("ixNeedsHungerConsumes", 0.1, "How much hunger consumed per ThinkDelay", nil, {
	data = {min = 0, max = 10, decimals = 1},
	category = "Needs"
})

ix.config.Add("ixNeedsThirstConsumes", 0.2, "How much hunger consumed per ThinkDelay", nil, {
	data = {min = 0, max = 10, decimals = 1},
	category = "Needs"
})

-- To do
-- Client bar
if (CLIENT) then
    ix.bar.Add(function()
        return LocalPlayer():GetLocalVar("hunger")/100                
    end, Color(200, 200, 40), nil, "hunger")

    ix.bar.Add(function()
        return LocalPlayer():GetLocalVar("thirst")/100                
    end, Color(127, 195, 255), nil, "thirst")

    function PLUGIN:ShouldBarDraw(bar)
        if ((bar == "hunger") or (bar == "thirst")) then
            return IsValid(LocalPlayer()) and IsValid(LocalPlayer():GetCharacter())
        end
    end
end