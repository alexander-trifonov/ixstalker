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

ix.command.Add("voiceJoke", {
	description = "Tell a joke to nearby stalkers",
	arguments = {
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, style)
        if (client:IsFemale()) then
            return "Для девушек эта функция недоступна"
        end
        if ((style == nil) or (styles[style] == nil)) then
            local string = "Use /voiceJoke "
            for k,v in pairs(styles) do
                string = string..k.." | "
            end
            return string
		end
        local intro = Sound(styles[style].jokeIntro[math.random(1, #styles[style].jokeIntro)])
        local introID = ix.playsound.Play(client, intro)

        local sound = Sound(styles[style].joke[math.random(1, #styles[style].joke)])
        ix.chat.Send(client, "me", "рассказывает анекдот")
        timer.Simple(NewSoundDuration(intro), function()
            -- if new sound is playing, don't play the music
            if (introID != client:GetData("soundID")) then
                return false
            end
            local soundID = ix.playsound.Play(client, sound)

            timer.Simple(NewSoundDuration(sound), function()
                if (soundID != client:GetData("soundID")) then
                    return false
                end
                local entities = ents.FindInSphere(client:GetPos(), 250)
                for k,v in pairs(entities) do
                    if (v:IsPlayer()) then
                        v:ChatNotify("Вы услышали анекдот, и вам стало приятно на душе")
                        v:Notify("Вы можете отреагировать используя /voiceLaugh, /voiceReact")
                    end
                end
            end)
        end)
	end
})

ix.command.Add("voiceLaugh", {
	description = "Laugh with or at someone",
	arguments = {
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, style)
        if (client:IsFemale()) then
            return "Для девушек эта функция недоступна"
        end
		if ((style == nil) or (styles[style] == nil)) then
            local string = "/voiceLaugh "
            for k,v in pairs(styles) do
                string = string..k.." | "
            end
            return string
		end
        local sound = styles[style].laugh[math.random(1, #styles[style].laugh)]
        ix.playsound.Play(client, sound)
        ix.chat.Send(client, "me", "смеется")
	end
})

ix.command.Add("voiceReact", {
	description = "React at bad joke",
	arguments = {
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, style)
        if (client:IsFemale()) then
            return "Для девушек эта функция недоступна"
        end
		if ((style == nil) or (styles[style] == nil)) then
            local string = "/voiceReact "
            for k,v in pairs(styles) do
                string = string..k.." | "
            end
            return string
		end
        local sound = styles[style].jokeReactionBad[math.random(1, #styles[style].jokeReactionBad)]
        ix.playsound.Play(client, sound)
        ix.chat.Send(client, "me", "выражает недовольство")
	end
})