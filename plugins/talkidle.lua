local PLUGIN = PLUGIN
PLUGIN.name = "Idle voices"
PLUGIN.author = "Mobious"
PLUGIN.description = "Whine how bad everything is"

styles["stalker"].idle = {
    "stalker/idle/idle_1.ogg.mp3",
    "stalker/idle/idle_2.ogg.mp3",
    "stalker/idle/idle_3.ogg.mp3",
    "stalker/idle/idle_4.ogg.mp3",
    "stalker/idle/idle_5.ogg.mp3",
    "stalker/idle/idle_6.ogg.mp3",
    "stalker/idle/idle_7.ogg.mp3",
    "stalker/idle/idle_8.ogg.mp3",
    "stalker/idle/idle_9.ogg.mp3",
    "stalker/idle/idle_10.ogg.mp3",
    "stalker/idle/idle_11.ogg.mp3",
    "stalker/idle/idle_12.ogg.mp3",
    "stalker/idle/idle_13.ogg.mp3",
    "stalker/idle/idle_14.ogg.mp3",
    "stalker/idle/idle_15.ogg.mp3",
    "stalker/idle/idle_16.ogg.mp3",
    "stalker/idle/idle_17.ogg.mp3",
    "stalker/idle/idle_18.ogg.mp3",
    "stalker/idle/idle_19.ogg.mp3",
    "stalker/idle/idle_20.ogg.mp3",
    "stalker/idle/idle_21.ogg.mp3",
    "stalker/idle/idle_22.ogg.mp3",
    "stalker/idle/idle_23.ogg.mp3",
    "stalker/idle/idle_24.ogg.mp3",
    "stalker/idle/idle_25.ogg.mp3",
    "stalker/idle/idle_26.ogg.mp3",
    "stalker/idle/idle_27.ogg.mp3",
    "stalker/idle/idle_28.ogg.mp3",
    "stalker/idle/idle_29.ogg.mp3",
    "stalker/idle/idle_30.ogg.mp3",
    "stalker/idle/idle_31.ogg.mp3",
    "stalker/idle/idle_32.ogg.mp3",
    "stalker/idle/idle_33.ogg.mp3",
    "stalker/idle/idle_34.ogg.mp3",
    "stalker/idle/idle_35.ogg.mp3",
    "stalker/idle/idle_36.ogg.mp3",
    "stalker/idle/idle_37.ogg.mp3"
}

styles["bandit"].idle = {
    "bandit/idle/idle_1.ogg.mp3",
    "bandit/idle/idle_2.ogg.mp3",
    "bandit/idle/idle_3.ogg.mp3",
    "bandit/idle/idle_4.ogg.mp3",
    "bandit/idle/idle_5.ogg.mp3",
    "bandit/idle/idle_6.ogg.mp3",
    "bandit/idle/idle_7.ogg.mp3",
    "bandit/idle/idle_8.ogg.mp3",
    "bandit/idle/idle_9.ogg.mp3",
    "bandit/idle/idle_10.ogg.mp3",
    "bandit/idle/idle_11.ogg.mp3",
    "bandit/idle/idle_12.ogg.mp3",
    "bandit/idle/idle_13.ogg.mp3",
    "bandit/idle/idle_14.ogg.mp3",
    "bandit/idle/idle_15.ogg.mp3",
    "bandit/idle/idle_16.ogg.mp3",
    "bandit/idle/idle_17.ogg.mp3",
    "bandit/idle/idle_18.ogg.mp3",
    "bandit/idle/idle_19.ogg.mp3",
    "bandit/idle/idle_20.ogg.mp3",
    "bandit/idle/idle_21.ogg.mp3",
    "bandit/idle/idle_22.ogg.mp3",
    "bandit/idle/idle_23.ogg.mp3",
    "bandit/idle/idle_24.ogg.mp3",
    "bandit/idle/idle_25.ogg.mp3",
    "bandit/idle/idle_26.ogg.mp3",
    "bandit/idle/idle_27.ogg.mp3",
    "bandit/idle/idle_28.ogg.mp3",
    "bandit/idle/idle_29.ogg.mp3",
    "bandit/idle/idle_30.ogg.mp3",
    "bandit/idle/idle_31.ogg.mp3",
    "bandit/idle/idle_32.ogg.mp3"
}

ix.command.Add("voiceIdle", {
	description = "Say something if you are tired",
    arguments = {
		bit.bor(ix.type.string, ix.type.optional)
	},
	OnRun = function(self, client, style)
        if (client:IsFemale()) then
            return "Для девушек эта функция недоступна"
        end
        if ((style == nil) or (styles[style] == nil)) then
              local string = "Use /voiceIdle "
            for k,v in pairs(styles) do
                string = string..k.." | "
            end
            return string
		end

        local sound = styles[style].idle[math.random(1, #styles[style].idle)]
        ix.playsound.Play(client, sound)
        ix.chat.Send(client, "me", "что-то бубнит себе под нос")
	end
})