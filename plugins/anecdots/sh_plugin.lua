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
            "bandit/talk/laugh/laughter_1.ogg.mp3",
            "bandit/talk/laugh/laughter_2.ogg.mp3",
            "bandit/talk/laugh/laughter_3.ogg.mp3",
            "bandit/talk/laugh/laughter_4.ogg.mp3",
            "bandit/talk/laugh/laughter_5.ogg.mp3",
            "bandit/talk/laugh/laughter_6.ogg.mp3",
            "bandit/talk/laugh/laughter_7.ogg.mp3"
        },
        ["jokeReactionBad"] = {
            "bandit/talk/reaction/reaction_joke_1.ogg.mp3",
            "bandit/talk/reaction/reaction_joke_2.ogg.mp3",
            "bandit/talk/reaction/reaction_joke_3.ogg.mp3"
        },
        ["joke"] = {
            "bandit/talk/jokes/joke_1.ogg.mp3",
            "bandit/talk/jokes/joke_2.ogg.mp3",
            "bandit/talk/jokes/joke_3.ogg.mp3",
            "bandit/talk/jokes/joke_4.ogg.mp3",
            "bandit/talk/jokes/joke_5.ogg.mp3",
            "bandit/talk/jokes/joke_6.ogg.mp3",
            "bandit/talk/jokes/joke_7.ogg.mp3",
            "bandit/talk/jokes/joke_8.ogg.mp3",
            "bandit/talk/jokes/joke_9.ogg.mp3",
            "bandit/talk/jokes/joke_10.ogg.mp3",
            "bandit/talk/jokes/joke_11.ogg.mp3"
        },
        ["jokeIntro"] = {
            "bandit/talk/intros/intro_joke_1.ogg.mp3",
            "bandit/talk/intros/intro_joke_2.ogg.mp3",
            "bandit/talk/intros/intro_joke_3.ogg.mp3",
            "bandit/talk/intros/intro_joke_4.ogg.mp3",
            "bandit/talk/intros/intro_joke_5.ogg.mp3"
        }
    },
    ["stalker"] = {
        ["laugh"] = {
            "stalker/talk/laugh/laughter_1.ogg.mp3",
            "stalker/talk/laugh/laughter_2.ogg.mp3",
            "stalker/talk/laugh/laughter_3.ogg.mp3",
            "stalker/talk/laugh/laughter_4.ogg.mp3",
            "stalker/talk/laugh/laughter_5.ogg.mp3",
            "stalker/talk/laugh/laughter_6.ogg.mp3"
        },
        ["jokeReactionBad"] = {
            "stalker/talk/reaction/reaction_joke_1.ogg.mp3",
            "stalker/talk/reaction/reaction_joke_2.ogg.mp3"
        },
        ["joke"] = {
            "stalker/talk/jokes/joke_1.ogg.mp3",
            "stalker/talk/jokes/joke_2.ogg.mp3",
            "stalker/talk/jokes/joke_3.ogg.mp3",
            "stalker/talk/jokes/joke_4.ogg.mp3",
            "stalker/talk/jokes/joke_5.ogg.mp3",
            "stalker/talk/jokes/joke_6.ogg.mp3",
            "stalker/talk/jokes/joke_7.ogg.mp3",
            "stalker/talk/jokes/joke_8.ogg.mp3",
            "stalker/talk/jokes/joke_9.ogg.mp3",
            "stalker/talk/jokes/joke_10.ogg.mp3",
            "stalker/talk/jokes/joke_11.ogg.mp3",
            "stalker/talk/jokes/joke_12.ogg.mp3"
        },
        ["jokeIntro"] = {
            "stalker/talk/intros/intro_joke_1.ogg.mp3",
            "stalker/talk/intros/intro_joke_2.ogg.mp3",
            "stalker/talk/intros/intro_joke_3.ogg.mp3",
            "stalker/talk/intros/intro_joke_4.ogg.mp3"
        }
    }
}

ix.command.Add("joke", {
	description = "Tell a joke to nearby stalkers",
	superAdminOnly = true,
	arguments = {
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, style)
        if ((style == nil) or (styles[style] == nil)) then
            local string = "Use /joke "
            for k,v in pairs(styles) do
                string = string..k.." | "
            end
            return string
		end
        local intro = Sound(styles[style].jokeIntro[math.random(1, #styles[style].jokeIntro)])
        client:EmitSound(intro)
        timer.Simple(NewSoundDuration(intro), function()
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
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, style)
		if ((style == nil) or (styles[style] == nil)) then
            local string = "/laugh "
            for k,v in pairs(styles) do
                string = string..k.." | "
            end
            return string
		end
        client:EmitSound(styles[style].laugh[math.random(1, #styles[style].laugh)])
	end
})

ix.command.Add("react", {
	description = "React at bad joke",
	superAdminOnly = true,
	arguments = {
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, style)
		if ((style == nil) or (styles[style] == nil)) then
            local string = "/react "
            for k,v in pairs(styles) do
                string = string..k.." | "
            end
            return string
		end
        client:EmitSound(styles[style].jokeReactionBad[math.random(1, #styles[style].jokeReactionBad)])
	end
})