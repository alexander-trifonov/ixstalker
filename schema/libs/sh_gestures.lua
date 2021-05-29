--male citizen: "g_righthandheavy" -> "g_righthandheavyapexarms"

ix.gestures = ix.gestures or {}


if (SERVER) then
    util.AddNetworkString("ixGesturesPlay")

    function ix.gestures.Play(client, sequence)
        net.Start("ixGesturesPlay")
        net.WriteString(sequence)
        net.Send(client)
        print("playing")
        client:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, client:LookupSequence(sequence), 0, true);
    end
end

do
    if (CLIENT) then
        net.Receive("ixGesturesPlay", function()
            print("playing")
            local sequence = net.ReadString()
            LocalPlayer():AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, LocalPlayer():LookupSequence(sequence), 0, true);
        end)
    end

    ix.command.Add("play", {
        description = "Play a gesture",
        superAdminOnly = false,
        arguments = {
            ix.type.text
        },
        OnRun = function(self, client, sequence)
            ix.gestures.Play(client, sequence)
        end
    })
end