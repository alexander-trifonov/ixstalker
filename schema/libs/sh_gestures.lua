--male citizen: "g_righthandheavy" -> "g_righthandheavyapexarms"

ix.gestures = ix.gestures or {}


if (SERVER) then
    util.AddNetworkString("ixGesturesPlay")

    function ix.gestures.Play(client, sequence, autokill)
        autokill = autokill or false
        net.Start("ixGesturesPlay")
        net.WriteString(sequence)
        net.WriteBool(autokill)
        net.Send(client)
        client:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, client:LookupSequence(sequence), 0, autokill);
    end
end

if (CLIENT) then
    function ix.gestures.Play(sequence, autokill)
        autokill = autokill or false
        net.Start("ixGesturesPlay")
        net.WriteString(sequence)
        net.WriteBool(autokill)
        net.SendToServer()
        LocalPlayer():AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, client:LookupSequence(sequence), 0, autokill);
    end
end

do
    if (SERVER) then
        net.Receive("ixGesturesPlay", function(length, client)
            local sequence = net.ReadString()
            local autokill = net.ReadBool()
            client:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, client:LookupSequence(sequence), 0, autokill);
        end)
    end

    if (CLIENT) then
        net.Receive("ixGesturesPlay", function()
            local sequence = net.ReadString()
            local autokill = net.ReadBool()
            LocalPlayer():AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, LocalPlayer():LookupSequence(sequence), 0, autokill);
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