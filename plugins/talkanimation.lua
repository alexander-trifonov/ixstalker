local PLUGIN = PLUGIN
PLUGIN.name = "Talking animation"
PLUGIN.author = "Mobious"
PLUGIN.description = "Make people play selected gestures when they talk"

local gestures = {
    ["male"] = {
        ["normal"] = {
            "g_look",
            "g_righthandheavy",
            "g_palm_out_high_L",
            "g_point_L",
            "g_medpuct_mid",
            "g_puncuate"
        }
    },
    ["female"] = {
        ["normal"] = {
            "g_display_left",
            "g_left_openhand",
            "g_right_openhand"
        }
    }
}

-- @realm server
function PLUGIN:PlayerMessageSend(client, info)
    if (!client:IsWepRaised()) then
        local gender = "male"
        local style = "normal"
        if (client:IsFemale()) then
            gender = "female"
        end
        local animation = gestures[gender][style][math.random(1, #gestures[gender][style])]
        ix.gestures.Play(client, animation, true)
    end
end