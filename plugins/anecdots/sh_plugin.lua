PLUGIN.name = "Anecdots"
PLUGIN.author = "Mobious"
PLUGIN.description = "Penis jokes"
PLUGIN.license = [[
you cannot use penis jokes without penis permissions
]]


-- 1. Need to choose anecdot's style: bandit, normal, dolg/freedom, etc
--      Gui? I don't want to T_T I need to hire someone who will do gui..
-- 2. /anecdot -> intros/intro_joke -> jokes/joke -> everybody reacts
-- 3. How do they react? 
    -- Can automate, but it's bad for communication ?
    -- Can make notification: "Use /laugh or /notfunny"
--

styles = {
    ["bandit"] = {
        ["laugh"] = {
            "wav"
        },
        ["reaction"] = {
            "wav"
        },
        ["joke"] = {
            "sound/bandit/talk/jokes/joke_1.mp3"
        },
        ["jokeIntro"] = {
            "wav"
        }
    },
    ["stalker"] = {
        ["laugh"] = {
            "wav"
        },
        ["reaction"] = {
            "wav"
        },
        ["joke"] = {
            "wav"
        },
        ["jokeIntro"] = {
            "wav"
        }
    }
}

ix.command.Add("joke", {
	description = "Tell a joke to nearby stalkers",
	superAdminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, style)
        if ((style == nil) or (styles[style] == nil)) then
            local string = "Use /joke "
            for k,v in pairs(styles) do
                string = string..k.."|"
            end
            return string
		end
        client:EmitSound(styles[style].jokeIntro[math.random(1, #styles[style].jokeIntro)])
        timer.Simple(2, function()
            local sound = Sound(styles[style].joke[math.random(1, #styles[style].joke)])
            client:EmitSound(sound)
            -- SoundDuration not working on ogg
            -- Not working on mp3 either, tried  ffmpeg
            -- Todo: convert all ogg to wav/mp3
            -- mp3 works, but use NewSoundDuration
            print(NewSoundDuration(sound))
            timer.Simple(NewSoundDuration(sound), function()
                local entities = ents.FindInSphere(client:GetPos(), 250)
                for k,v in pairs(entities) do
                    if (v:IsPlayer()) then
                        v:ChatNotify("Вы услышали анекдот, и вам стало приятно на душе")
                        v:Notify("Вы можете отреагировать используя /laugh, /react")
                    end
                end
            end)
        end)
	end
})

ix.command.Add("laugh", {
	description = "Laugh with or at someone",
	superAdminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, style)
		if ((style == nil) or (!IsValid(styles.style))) then
            local string = "/laugh "
            for k,v in styles do
                string = string..k.."/"
            end
            return string
		end
        client:EmitSound(styles.style.laugh[math.random(1, #styles.style.laugh)])
	end
})

ix.command.Add("react", {
	description = "React at bad joke",
	superAdminOnly = true,
	arguments = {
		ix.type.string
	},
	OnRun = function(self, client, style)
		if ((style == nil) or (!IsValid(styles.style))) then
            local string = "/react "
            for k,v in styles do
                string = string..k.."/"
            end
            return string
		end
        client:EmitSound(styles.style.react[math.random(1, #styles.style.react)])
	end
})