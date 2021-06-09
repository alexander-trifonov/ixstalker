PLUGIN.name = "Ambient"
PLUGIN.author = "Mobious"
PLUGIN.description = "Plays the penis music in background"

ambient = ambient or {}
ambient.normal = {
    --"stalker/talk/intros/intro_music_1.ogg.mp3"
    "music/hl1_song14.mp3"
}

ix.lang.AddTable("english", {
	optEnableAmbientMusic = "Enable ambient music",
    optdEnableAmbientMusic = "Music will begin to play in ~5 seconds until"
})


if (CLIENT) then
    ix.option.Add("enableAmbientMusic", ix.type.bool, true, {
		category = "music",
        OnChanged = function(oldValue, newValue)
            if (newValue) then
                hook.Run("PlayAmbientMusic")
            else
                hook.Run("StopAmbientMusic")
            end
        end
	})

    local playerMeta = FindMetaTable("Player")

    function playerMeta:StopAmbient()
        if (self.ambient != nil) then
            --self.ambient:FadeOut(1.5)
            self.ambient:Stop()
            self.ambient = nil
            self.ambientID = nil
        end
    end

    function playerMeta:PlayAmbient(sound, genre, forced)
        self:StopAmbient()
        self.ambient = CreateSound(self, sound)
        local ambientID = sound..math.random(1, 1000)
        self.ambientID = ambientID
        if (!forced) then
            if (ix.option.Get("enableAmbientMusic") == false) then
                return false
            end
        end
        -- if (self.ambientID != ambientID) then
        --     return false
        -- end
        self.ambient:Play()
        -- Play next
        timer.Simple(NewSoundDuration(sound), function()
            print(NewSoundDuration(sound))
            if (!forced) then
                if (ix.option.Get("enableAmbientMusic") == false) then
                    return false
                end
            end
            if (self.ambientID != ambientID) then
                return false
            end
            --self:StopAmbient()
            hook.Run("PlayAmbientMusic", genre, forced)
        end)
        -- timer.Simple(5, function()
        -- end)
    end
end

if (CLIENT) then
    function PLUGIN:PlayAmbientMusic(genre, forced)
        forced = forced or false
        genre = genre or "normal"
        local client = LocalPlayer()
        if (ambient[genre] == nil) then return false end
        
        local sound = ambient[genre][math.random(1, #ambient[genre])]
        client:PlayAmbient(sound, genre, forced)
    end

    function PLUGIN:StopAmbientMusic()
        local client = LocalPlayer()
        client:StopAmbient()
    end


    net.Receive("ixPlayAmbientMusic", function()
        hook.Run("PlayAmbientMusic")
    end)
end
    
if (SERVER) then
    util.AddNetworkString("ixPlayAmbientMusic");
    
    function PLUGIN:CharacterLoaded(character)
        net.Start("ixPlayAmbientMusic")
        net.Send(character:GetPlayer())
    end
end
-- ix.command.Add("music", {
-- description = "Play an ambient music",
-- arguments = {},
-- superAdminOnly = true,
-- OnRun = function(self, client)
--     net.Start("ixPlayAmbientMusic")
--     net.Send(client)
-- end
-- })